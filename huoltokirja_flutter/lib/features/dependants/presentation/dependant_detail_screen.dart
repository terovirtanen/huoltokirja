import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/dependant.dart';
import '../../../domain/models/note.dart';
import '../../../domain/models/scheduler.dart';
import '../../../domain/services/counter_estimator.dart';
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
          final usageEstimate = estimateDependantUsage(
            dependant: data.dependant,
            notes: data.notes,
          );

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Card(
                child: ListTile(
                  title: Text(data.dependant.name),
                  subtitle: Text(
                    _buildDependantSubtitle(
                      context,
                      data.dependant,
                      usageEstimate,
                      dateFormat,
                    ),
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
                  usageEstimate: usageEstimate,
                  usageUnit: data.dependant.usageUnit,
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

String _buildDependantSubtitle(
  BuildContext context,
  Dependant dependant,
  UsageEstimate? usageEstimate,
  DateFormat dateFormat,
) {
  final l10n = context.l10n;
  final parts = <String>[
    switch (dependant.dependantGroup) {
      DependantGroup.none => l10n.noGroup,
      DependantGroup.vehicle => l10n.vehicleGroup,
      DependantGroup.workMachine => l10n.workMachineGroup,
      DependantGroup.device => l10n.deviceGroup,
      DependantGroup.animal => l10n.animalGroup,
    },
  ];

  if (dependant.initialDate != null) {
    parts.add(
      l10n.initialDateValue(
        dependant.dependantGroup == DependantGroup.animal
            ? l10n.birthDateShort
            : l10n.commissioningDateShort,
        dateFormat.format(dependant.initialDate!),
      ),
    );
  }
  if (dependant.usage != null && dependant.usageUnit != null) {
    parts.add(
      l10n.usageValueLabel(
        dependant.dependantGroup == DependantGroup.vehicle
            ? l10n.odometerShort
            : l10n.operatingHoursShort,
        _formatUsage(dependant.usage!),
        dependant.usageUnit!,
      ),
    );
  }
  if (usageEstimate != null && dependant.usageUnit != null) {
    parts.add(
      l10n.usageEstimateLine(
        _formatUsage(usageEstimate.currentValue),
        dependant.usageUnit!,
      ),
    );
  }

  return parts.join('\n');
}

String _formatUsage(double value) {
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

class _SchedulerTile extends StatelessWidget {
  const _SchedulerTile({
    required this.scheduler,
    required this.usageEstimate,
    required this.usageUnit,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final Scheduler scheduler;
  final UsageEstimate? usageEstimate;
  final String? usageUnit;
  final DateFormat dateFormat;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final nextScheduleAt =
        scheduler.nextScheduleAtForEstimate(usageEstimate: usageEstimate) ??
        scheduler.startDate;
    final daysUntil = nextScheduleAt
        .difference(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        )
        .inDays;
    final statusSuffix = daysUntil < 0
        ? context.l10n.overdueSuffix
        : daysUntil <= 1
        ? context.l10n.dueTomorrowSuffix
        : daysUntil <= 14
        ? context.l10n.dueSoonSuffix
        : '';

    final details = <String>[
      context.l10n.schedulerTypeLine(
        _noteTypeLabel(context, scheduler.noteType),
      ),
      if (scheduler.calendarIntervalMonths != null)
        context.l10n.schedulerCalendarLine(
          _calendarIntervalLabel(context, scheduler.calendarIntervalMonths!),
        ),
      if (scheduler.nextUsageThreshold != null && usageUnit != null)
        context.l10n.schedulerUsageLine(
          _formatUsage(scheduler.nextUsageThreshold!),
          usageUnit!,
        ),
      context.l10n.nextSchedule(
        dateFormat.format(nextScheduleAt),
        statusSuffix,
      ),
    ];

    return Card(
      child: ListTile(
        title: Text(scheduler.label),
        subtitle: Text(details.join('\n')),
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

  String _noteTypeLabel(BuildContext context, NoteType type) {
    final l10n = context.l10n;
    return switch (type) {
      NoteType.plain => l10n.plainNote,
      NoteType.service => l10n.serviceNote,
      NoteType.inspection => l10n.inspectionNote,
    };
  }

  String _calendarIntervalLabel(BuildContext context, int months) {
    final l10n = context.l10n;
    return switch (months) {
      12 => l10n.yearly,
      6 => l10n.semiAnnual,
      3 => l10n.quarterly,
      _ => l10n.everyNMonths(months),
    };
  }
}
