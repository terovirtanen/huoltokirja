import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../domain/models/note.dart';
import '../../../domain/models/scheduler.dart';
import '../../../shared/widgets/state_widgets.dart';

class DependantDetailScreen extends ConsumerWidget {
  const DependantDetailScreen({super.key, required this.dependantId});

  final int dependantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(dependantDetailProvider(dependantId));
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Riippuvaisen tiedot')),
      body: detailAsync.when(
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(dependantDetailProvider(dependantId)),
        ),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Card(
                child: ListTile(
                  title: Text(data.dependant.name),
                  subtitle: Text(
                    data.dependant.relation == null
                        ? 'Ei suhdetta'
                        : 'Suhde: ${data.dependant.relation}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Notet'),
                trailing: FilledButton.icon(
                  onPressed: () =>
                      context.push('/dependants/$dependantId/notes/new'),
                  icon: const Icon(Icons.add),
                  label: const Text('Lisaa note'),
                ),
              ),
              if (data.notes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Ei noteja.'),
                ),
              ...data.notes.map(
                (note) => _NoteTile(
                  note: note,
                  dateFormat: dateFormat,
                  onEdit: () => context.push(
                    '/dependants/$dependantId/notes/${note.id}/edit',
                  ),
                  onDelete: () async {
                    await ref.read(noteRepositoryProvider).delete(note.id!);
                    ref.invalidate(dependantDetailProvider(dependantId));
                  },
                ),
              ),
              const Divider(height: 32),
              ListTile(
                title: const Text('Schedulerit'),
                trailing: FilledButton.icon(
                  onPressed: () =>
                      context.push('/dependants/$dependantId/schedulers/new'),
                  icon: const Icon(Icons.add),
                  label: const Text('Lisaa scheduler'),
                ),
              ),
              if (data.schedulers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Ei schedulereita.'),
                ),
              ...data.schedulers.map(
                (scheduler) => _SchedulerTile(
                  scheduler: scheduler,
                  dateFormat: dateFormat,
                  onEdit: () => context.push(
                    '/dependants/$dependantId/schedulers/${scheduler.id}/edit',
                  ),
                  onDelete: () async {
                    await ref
                        .read(schedulerRepositoryProvider)
                        .delete(scheduler.id!);
                    ref.invalidate(dependantDetailProvider(dependantId));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({
    required this.note,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final Note note;
  final DateFormat dateFormat;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.listText),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') onEdit();
            if (value == 'delete') await onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Muokkaa')),
            PopupMenuItem(value: 'delete', child: Text('Poista')),
          ],
        ),
      ),
    );
  }
}

class _SchedulerTile extends StatelessWidget {
  const _SchedulerTile({
    required this.scheduler,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final Scheduler scheduler;
  final DateFormat dateFormat;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final nextDate = dateFormat.format(scheduler.nextScheduleAt);
    final overdue = scheduler.isOverdue ? ' (myohassa)' : '';

    return Card(
      child: ListTile(
        title: Text(scheduler.label),
        subtitle: Text('Seuraava: $nextDate$overdue'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') onEdit();
            if (value == 'delete') await onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Muokkaa')),
            PopupMenuItem(value: 'delete', child: Text('Poista')),
          ],
        ),
      ),
    );
  }
}
