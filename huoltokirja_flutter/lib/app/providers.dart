import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../data/mappers/dependant_mapper.dart';
import '../data/mappers/note_mapper.dart';
import '../data/mappers/scheduler_mapper.dart';
import '../data/repositories/sqflite_dependant_repository.dart';
import '../data/repositories/sqflite_note_repository.dart';
import '../data/repositories/sqflite_scheduler_repository.dart';
import '../domain/models/dependant.dart';
import '../domain/models/note.dart';
import '../domain/models/scheduler.dart';
import '../domain/repositories/dependant_repository.dart';
import '../domain/repositories/note_repository.dart';
import '../domain/repositories/scheduler_repository.dart';
import '../domain/services/counter_estimator.dart';

final appDatabaseProvider = Provider<AppDatabase>((_) {
  throw UnimplementedError('AppDatabase must be overridden in main.dart');
});

final dependantRepositoryProvider = Provider<DependantRepository>((ref) {
  return SqfliteDependantRepository(
    ref.watch(appDatabaseProvider),
    const DependantMapper(),
  );
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return SqfliteNoteRepository(
    ref.watch(appDatabaseProvider),
    const NoteMapper(),
  );
});

final schedulerRepositoryProvider = Provider<SchedulerRepository>((ref) {
  return SqfliteSchedulerRepository(
    ref.watch(appDatabaseProvider),
    const SchedulerMapper(),
  );
});

class AllNotesFeedItem {
  const AllNotesFeedItem({required this.note, required this.dependant});

  final Note note;
  final Dependant dependant;
}

final allNotesFeedProvider = FutureProvider.autoDispose<List<AllNotesFeedItem>>(
  (ref) async {
    final dependants = await ref.read(dependantRepositoryProvider).getAll();
    final notes = await ref.read(noteRepositoryProvider).listAll();
    final dependantsById = {
      for (final dependant in dependants)
        if (dependant.id != null) dependant.id!: dependant,
    };

    final items = notes
        .where((note) => dependantsById.containsKey(note.dependantId))
        .map(
          (note) => AllNotesFeedItem(
            note: note,
            dependant: dependantsById[note.dependantId]!,
          ),
        )
        .toList(growable: false);

    items.sort((a, b) {
      final dateComparison = b.note.noteDate.compareTo(a.note.noteDate);
      if (dateComparison != 0) {
        return dateComparison;
      }
      return b.note.createdAt.compareTo(a.note.createdAt);
    });

    return items;
  },
);

final dependantNotesProvider = FutureProvider.autoDispose
    .family<List<Note>, int>((ref, dependantId) {
      return ref.read(noteRepositoryProvider).listByDependant(dependantId);
    });

final dependantUsageEstimateProvider = FutureProvider.autoDispose
    .family<UsageEstimate?, int>((ref, dependantId) async {
      final dependant = await ref
          .read(dependantRepositoryProvider)
          .getById(dependantId);
      if (dependant == null) {
        return null;
      }

      final notes = await ref
          .read(noteRepositoryProvider)
          .listByDependant(dependantId);
      return estimateDependantUsage(dependant: dependant, notes: notes);
    });

final dependantListControllerProvider =
    AsyncNotifierProvider<DependantListController, List<Dependant>>(
      DependantListController.new,
    );

class DependantListController extends AsyncNotifier<List<Dependant>> {
  @override
  Future<List<Dependant>> build() {
    return ref.read(dependantRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(dependantRepositoryProvider).getAll(),
    );
  }

  Future<void> create(Dependant dependant) async {
    await ref.read(dependantRepositoryProvider).create(dependant);
    await refresh();
  }

  Future<void> updateDependant(Dependant dependant) async {
    await ref.read(dependantRepositoryProvider).update(dependant);
    await refresh();
  }

  Future<void> delete(int dependantId) async {
    await ref.read(dependantRepositoryProvider).delete(dependantId);
    await refresh();
  }
}

class DependantDetailData {
  const DependantDetailData({
    required this.dependant,
    required this.notes,
    required this.schedulers,
  });

  final Dependant dependant;
  final List<Note> notes;
  final List<Scheduler> schedulers;
}

final dependantDetailProvider = FutureProvider.autoDispose
    .family<DependantDetailData, int>((ref, dependantId) async {
      final dependant = await ref
          .read(dependantRepositoryProvider)
          .getById(dependantId);
      if (dependant == null) {
        throw StateError('Dependant $dependantId not found');
      }

      final notesFuture = ref
          .read(noteRepositoryProvider)
          .listByDependant(dependantId);
      final schedulersFuture = ref
          .read(schedulerRepositoryProvider)
          .listByDependant(dependantId);

      final notes = await notesFuture;
      final schedulers = await schedulersFuture;

      return DependantDetailData(
        dependant: dependant,
        notes: notes,
        schedulers: schedulers,
      );
    });
