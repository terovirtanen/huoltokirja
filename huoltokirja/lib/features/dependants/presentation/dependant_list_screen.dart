import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/dependant.dart';
import '../../../domain/services/dependant_tag_utils.dart';
import '../../../shared/widgets/app_menu_button.dart';
import '../../../shared/widgets/centered_snackbar.dart';
import '../../../shared/widgets/state_widgets.dart';
import 'dependant_editor_dialog.dart';

class DependantListScreen extends ConsumerWidget {
  const DependantListScreen({super.key, this.selectedTags = const {}});

  final Set<String> selectedTags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dependantsAsync = ref.watch(dependantListControllerProvider);
    final notesFeedAsync = ref.watch(allNotesFeedProvider);
    final sortOrder = ref.watch(dependantSortOrderProvider);
    final l10n = context.l10n;

    return Scaffold(
      drawer: AppMenuDrawer(selectedTags: selectedTags),
      appBar: AppBar(
        title: Text(l10n.appTitle),
        leading: const AppMenuButton(),
      ),
      body: dependantsAsync.when(
        data: (dependants) {
          if (dependants.isEmpty) {
            return EmptyState(
              title: l10n.dependantsEmptyTitle,
              subtitle: l10n.dependantsEmptySubtitle,
              action: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.person_add),
                label: Text(l10n.addDependant),
              ),
            );
          }

          final filteredDependants = dependants
              .where(
                (dependant) => matchesSelectedTags(dependant, selectedTags),
              )
              .toList(growable: false);

          final latestNoteByDependantId = <int, DateTime>{};
          notesFeedAsync.whenData((items) {
            for (final item in items) {
              final dependantId = item.dependant.id;
              if (dependantId == null) {
                continue;
              }
              final existing = latestNoteByDependantId[dependantId];
              if (existing == null || item.note.noteDate.isAfter(existing)) {
                latestNoteByDependantId[dependantId] = item.note.noteDate;
              }
            }
          });

          final sortedDependants = _sortDependants(
            filteredDependants,
            order: sortOrder,
            latestNoteByDependantId: latestNoteByDependantId,
          );

          if (sortedDependants.isEmpty) {
            return EmptyState(
              title: l10n.noMatchingTagsTitle,
              subtitle: l10n.noMatchingTagsSubtitle,
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(dependantListControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: sortedDependants.length,
              itemBuilder: (context, index) {
                final dependant = sortedDependants[index];
                final palette = _targetPalette();

                final subtitle = _buildSubtitle(dependant);

                return Card(
                  color: palette.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: palette.border),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: palette.accent.withValues(alpha: 0.14),
                      child: Icon(
                        _groupIcon(dependant.dependantGroup),
                        color: palette.accent,
                      ),
                    ),
                    title: Text(
                      dependant.listTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: subtitle == null ? null : Text(subtitle),
                    onTap: () => context.push('/dependants/${dependant.id}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditDialog(context, ref, dependant);
                        }
                        if (value == 'delete') {
                          _deleteDependant(context, ref, dependant.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () =>
              ref.read(dependantListControllerProvider.notifier).refresh(),
        ),
        loading: () => const LoadingState(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Dependant> _sortDependants(
    List<Dependant> dependants, {
    required DependantSortOrder order,
    required Map<int, DateTime> latestNoteByDependantId,
  }) {
    final sorted = List<Dependant>.from(dependants);

    if (order == DependantSortOrder.name) {
      sorted.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return sorted;
    }

    sorted.sort((a, b) {
      final aDate = a.id == null ? null : latestNoteByDependantId[a.id!];
      final bDate = b.id == null ? null : latestNoteByDependantId[b.id!];

      if (aDate != null && bDate != null) {
        final byDate = bDate.compareTo(aDate);
        if (byDate != 0) {
          return byDate;
        }
      } else if (aDate != null) {
        return -1;
      } else if (bDate != null) {
        return 1;
      }

      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return sorted;
  }

  String? _buildSubtitle(Dependant dependant) {
    final parts = <String>[];

    final tag = dependant.tag?.trim();
    if (tag != null && tag.isNotEmpty) {
      parts.add(tag);
    }

    return parts.isEmpty ? null : parts.join(' • ');
  }

  _TargetCardPalette _targetPalette() {
    return const _TargetCardPalette(
      background: Color(0xFFEAF4FF),
      border: Color(0xFF90CAF9),
      accent: Color(0xFF1565C0),
    );
  }

  IconData _groupIcon(DependantGroup group) {
    return switch (group) {
      DependantGroup.none => Icons.folder_outlined,
      DependantGroup.vehicle => Icons.directions_car_outlined,
      DependantGroup.workMachine => Icons.precision_manufacturing_outlined,
      DependantGroup.device => Icons.devices_other_outlined,
      DependantGroup.animal => Icons.pets_outlined,
    };
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Dependant>(
      context: context,
      builder: (_) => const DependantEditorDialog(),
    );
    if (result != null) {
      await ref.read(dependantListControllerProvider.notifier).create(result);
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Dependant dependant,
  ) async {
    final result = await showDialog<Dependant>(
      context: context,
      builder: (_) => DependantEditorDialog(initial: dependant),
    );
    if (result != null) {
      await ref
          .read(dependantListControllerProvider.notifier)
          .updateDependant(result);
    }
  }

  Future<void> _deleteDependant(
    BuildContext context,
    WidgetRef ref,
    int dependantId,
  ) async {
    await ref
        .read(dependantListControllerProvider.notifier)
        .delete(dependantId);
    if (context.mounted) {
      showCenteredSnackBar(context, context.l10n.dependantDeleted);
    }
  }
}

class _TargetCardPalette {
  const _TargetCardPalette({
    required this.background,
    required this.border,
    required this.accent,
  });

  final Color background;
  final Color border;
  final Color accent;
}
