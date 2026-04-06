import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dependantDetails)),
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
                        ? l10n.noRelation
                        : l10n.relationLabel(data.dependant.relation!),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text(l10n.notes),
                trailing: FilledButton.icon(
                  onPressed: () =>
                      context.push('/dependants/$dependantId/notes/new'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addNote),
                ),
              ),
              if (data.notes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.noNotes),
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
                title: Text(l10n.schedulers),
                trailing: FilledButton.icon(
                  onPressed: () =>
                      context.push('/dependants/$dependantId/schedulers/new'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addScheduler),
                ),
              ),
              if (data.schedulers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.noSchedulers),
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

  String _buildDetails(BuildContext context, Note note) {
    final buffer = StringBuffer();

    if (note.estimatedCounter != null) {
      buffer.write(
        context.l10n.counterEstimateSuffix(note.estimatedCounter.toString()),
      );
    }
    if (note.performerName != null && note.performerName!.trim().isNotEmpty) {
      buffer.write(context.l10n.inspectorSuffix(note.performerName!.trim()));
    }
    if (note.price != null) {
      buffer.write(context.l10n.priceSuffix(note.price!.toStringAsFixed(2)));
    }
    if (note.isApproved) {
      buffer.write(context.l10n.approvedSuffix);
    }

    return buffer.toString();
  }

  String _buildSubtitle(BuildContext context) {
    return switch (note) {
      PlainNote plain => context.l10n.plainNoteSummary(
        dateFormat.format(plain.noteDate),
        plain.body.trim().isEmpty
            ? ''
            : context.l10n.noteBodySuffix(plain.body.trim()),
      ),
      ServiceNote service => context.l10n.serviceNoteSummary(
        dateFormat.format(service.serviceDate),
        _buildDetails(context, service),
      ),
      InspectionNote inspection => context.l10n.inspectionNoteSummary(
        dateFormat.format(inspection.noteDate),
        _buildDetails(context, inspection),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(_buildSubtitle(context)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') onEdit();
            if (value == 'delete') await onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
            PopupMenuItem(value: 'delete', child: Text(context.l10n.delete)),
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
    final overdue = scheduler.isOverdue ? context.l10n.overdueSuffix : '';

    return Card(
      child: ListTile(
        title: Text(scheduler.label),
        subtitle: Text(context.l10n.nextSchedule(nextDate, overdue)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') onEdit();
            if (value == 'delete') await onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
            PopupMenuItem(value: 'delete', child: Text(context.l10n.delete)),
          ],
        ),
      ),
    );
  }
}
