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
import '../../notes/presentation/note_display_utils.dart';

class DependantDetailScreen extends ConsumerStatefulWidget {
  const DependantDetailScreen({super.key, required this.dependantId});

  final int dependantId;

  @override
  ConsumerState<DependantDetailScreen> createState() =>
      _DependantDetailScreenState();
}

class _DependantDetailScreenState extends ConsumerState<DependantDetailScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) {
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(dependantDetailProvider(widget.dependantId));
    final dateFormat = DateFormat.yMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dependantDetails)),
      body: detailAsync.when(
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(dependantDetailProvider(widget.dependantId)),
        ),
        data: (data) {
          final usageEstimate = estimateDependantUsage(
            dependant: data.dependant,
            notes: data.notes,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Card(
                  child: ListTile(
                    title: Text(data.dependant.name),
                    subtitle: _DependantHeaderSubtitle(
                      dependant: data.dependant,
                      notes: data.notes,
                      usageEstimate: usageEstimate,
                      dateFormat: dateFormat,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: _DetailPageSwitcher(
                  currentPage: _currentPage,
                  notesLabel: l10n.notes,
                  schedulersLabel: l10n.schedulers,
                  onSelected: _animateToPage,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  reverse: true,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    _NotesPage(
                      notes: data.notes,
                      dependantGroup: data.dependant.dependantGroup,
                      dateFormat: dateFormat,
                      onRefresh: () => ref.invalidate(
                        dependantDetailProvider(widget.dependantId),
                      ),
                      onAdd: () => context.push(
                        '/dependants/${widget.dependantId}/notes/new',
                      ),
                      onEdit: (note) => context.push(
                        '/dependants/${widget.dependantId}/notes/${note.id}/edit',
                      ),
                      onDelete: (note) async {
                        await ref.read(noteRepositoryProvider).delete(note.id!);
                        ref.invalidate(
                          dependantDetailProvider(widget.dependantId),
                        );
                      },
                    ),
                    _SchedulersPage(
                      dependantGroup: data.dependant.dependantGroup,
                      schedulers: data.schedulers,
                      usageEstimate: usageEstimate,
                      usageUnit: data.dependant.usageUnit,
                      dateFormat: dateFormat,
                      onRefresh: () => ref.invalidate(
                        dependantDetailProvider(widget.dependantId),
                      ),
                      onAdd: () => context.push(
                        '/dependants/${widget.dependantId}/schedulers/new',
                      ),
                      onEdit: (scheduler) => context.push(
                        '/dependants/${widget.dependantId}/schedulers/${scheduler.id}/edit',
                      ),
                      onDelete: (scheduler) async {
                        await ref
                            .read(schedulerRepositoryProvider)
                            .delete(scheduler.id!);
                        ref.invalidate(
                          dependantDetailProvider(widget.dependantId),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailPageSwitcher extends StatelessWidget {
  const _DetailPageSwitcher({
    required this.currentPage,
    required this.notesLabel,
    required this.schedulersLabel,
    required this.onSelected,
  });

  final int currentPage;
  final String notesLabel;
  final String schedulersLabel;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _DetailPageTab(
                label: notesLabel,
                icon: Icons.sticky_note_2_outlined,
                selected: currentPage == 0,
                onTap: () => onSelected(0),
              ),
            ),
            Expanded(
              child: _DetailPageTab(
                label: schedulersLabel,
                icon: Icons.event_repeat_outlined,
                selected: currentPage == 1,
                onTap: () => onSelected(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPageTab extends StatelessWidget {
  const _DetailPageTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotesPage extends StatelessWidget {
  const _NotesPage({
    required this.notes,
    required this.dependantGroup,
    required this.dateFormat,
    required this.onRefresh,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Note> notes;
  final DependantGroup dependantGroup;
  final DateFormat dateFormat;
  final VoidCallback onRefresh;
  final VoidCallback onAdd;
  final void Function(Note note) onEdit;
  final Future<void> Function(Note note) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView(
            key: const PageStorageKey('dependant-notes-page'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (notes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.noNotes),
                ),
              ...notes.map(
                (note) => _NoteTile(
                  note: note,
                  dependantGroup: dependantGroup,
                  dateFormat: dateFormat,
                  onEdit: () => onEdit(note),
                  onDelete: () => onDelete(note),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: SafeArea(
            top: false,
            child: Center(
              child: FloatingActionButton(
                heroTag: 'dependant-notes-add',
                onPressed: onAdd,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SchedulersPage extends StatelessWidget {
  const _SchedulersPage({
    required this.dependantGroup,
    required this.schedulers,
    required this.usageEstimate,
    required this.usageUnit,
    required this.dateFormat,
    required this.onRefresh,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final DependantGroup dependantGroup;
  final List<Scheduler> schedulers;
  final UsageEstimate? usageEstimate;
  final String? usageUnit;
  final DateFormat dateFormat;
  final VoidCallback onRefresh;
  final VoidCallback onAdd;
  final void Function(Scheduler scheduler) onEdit;
  final Future<void> Function(Scheduler scheduler) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView(
            key: const PageStorageKey('dependant-schedulers-page'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (schedulers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.noSchedulers),
                ),
              ...schedulers.map(
                (scheduler) => _SchedulerTile(
                  scheduler: scheduler,
                  dependantGroup: dependantGroup,
                  usageEstimate: usageEstimate,
                  usageUnit: usageUnit,
                  dateFormat: dateFormat,
                  onEdit: () => onEdit(scheduler),
                  onDelete: () => onDelete(scheduler),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: SafeArea(
            top: false,
            child: Center(
              child: FloatingActionButton(
                heroTag: 'dependant-schedulers-add',
                onPressed: onAdd,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({
    required this.note,
    required this.dependantGroup,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final Note note;
  final DependantGroup dependantGroup;
  final DateFormat dateFormat;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  String _buildDetails(BuildContext context, Note note) {
    final buffer = StringBuffer();

    if (note.estimatedCounter != null &&
        shouldShowCounterField(
          dependantGroup: dependantGroup,
          noteType: note.type,
        )) {
      final unit = dependantGroup.usageUnit ?? '';
      buffer.write(' • ${note.estimatedCounter}$unit');
    }
    if (note.performerName != null && note.performerName!.trim().isNotEmpty) {
      buffer.write(' • ${note.performerName!.trim()}');
    }
    if (note.price != null) {
      buffer.write(' • ${note.price!.toStringAsFixed(2)} €');
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
      ServiceNote service => localizedServiceNoteSummary(
        context.l10n,
        dependantGroup: dependantGroup,
        date: dateFormat.format(service.serviceDate),
        details: _buildDetails(context, service),
      ),
      InspectionNote inspection => context.l10n.inspectionNoteSummary(
        dateFormat.format(inspection.noteDate),
        _buildDetails(context, inspection),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = _notePalette(context, note);

    return Card(
      color: palette.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: palette.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: 0.14),
          child: Icon(_noteTypeIcon(note.type), color: palette.accent),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                note.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (note.isAutomaticallyCreated)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: palette.accent,
                ),
              ),
          ],
        ),
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

  IconData _noteTypeIcon(NoteType type) {
    return switch (type) {
      NoteType.plain => Icons.sticky_note_2_outlined,
      NoteType.service => Icons.build_circle_outlined,
      NoteType.inspection => Icons.fact_check_outlined,
    };
  }

  _DetailCardPalette _notePalette(BuildContext context, Note note) {
    final scheme = Theme.of(context).colorScheme;

    if (isPendingAutoCreatedPastNote(note)) {
      return _DetailCardPalette(
        background: Colors.red.shade50,
        border: Colors.red.shade300,
        accent: Colors.red.shade700,
      );
    }

    if (note.noteDate.isAfter(DateTime.now()) ||
        isPendingAutoCreatedCurrentOrFutureNote(note)) {
      return _DetailCardPalette(
        background: Colors.green.shade50,
        border: Colors.green.shade300,
        accent: Colors.green.shade700,
      );
    }

    return _DetailCardPalette(
      background: scheme.primaryContainer.withValues(alpha: 0.45),
      border: scheme.primary.withValues(alpha: 0.35),
      accent: scheme.primary,
    );
  }
}

String _buildDependantSubtitle(
  BuildContext context,
  Dependant dependant,
  List<Note> notes,
  UsageEstimate? usageEstimate,
  DateFormat dateFormat,
) {
  final l10n = context.l10n;
  final parts = <String>[];

  final tag = dependant.tag?.trim();
  if (tag != null && tag.isNotEmpty) {
    parts.add(tag);
  }

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
  if (usageEstimate != null &&
      dependant.usageUnit != null &&
      shouldShowUsageEstimate(
        dependant: dependant,
        estimate: usageEstimate,
        notes: notes,
      )) {
    parts.add(
      l10n.usageEstimateLine(
        _formatUsage(usageEstimate.currentValue),
        dependant.usageUnit!,
      ),
    );
  }

  return parts.join('\n');
}

class _DependantHeaderSubtitle extends StatelessWidget {
  const _DependantHeaderSubtitle({
    required this.dependant,
    required this.notes,
    required this.usageEstimate,
    required this.dateFormat,
  });

  final Dependant dependant;
  final List<Note> notes;
  final UsageEstimate? usageEstimate;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final metaText = _buildDependantSubtitle(
      context,
      dependant,
      notes,
      usageEstimate,
      dateFormat,
    );
    final description = dependant.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final lineHeight =
        (textStyle?.fontSize ?? 12) * (textStyle?.height ?? 1.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (metaText.isNotEmpty) Text(metaText),
        if (hasDescription) ...[
          if (metaText.isNotEmpty) const SizedBox(height: 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: lineHeight * 4),
            child: SingleChildScrollView(child: Text(description)),
          ),
        ],
      ],
    );
  }
}

String _formatUsage(double value) {
  return value.toStringAsFixed(0);
}

class _SchedulerTile extends StatelessWidget {
  const _SchedulerTile({
    required this.scheduler,
    required this.dependantGroup,
    required this.usageEstimate,
    required this.usageUnit,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final Scheduler scheduler;
  final DependantGroup dependantGroup;
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

    final nextUsageThreshold = scheduler.nextUsageThresholdForEstimate(
      usageEstimate,
    );
    final details = <String>[
      context.l10n.schedulerTypeLine(
        _noteTypeLabel(context, scheduler.noteType),
      ),
      if (scheduler.calendarIntervalMonths != null)
        context.l10n.schedulerCalendarLine(
          _calendarIntervalLabel(context, scheduler.calendarIntervalMonths!),
        ),
      if (nextUsageThreshold != null && usageUnit != null)
        context.l10n.schedulerUsageLine(
          _formatUsage(nextUsageThreshold),
          usageUnit!,
        ),
      context.l10n.nextSchedule(
        dateFormat.format(nextScheduleAt),
        statusSuffix,
      ),
    ];

    const palette = _DetailCardPalette(
      background: Color(0xFFEAF8EC),
      border: Color(0xFFA5D6A7),
      accent: Color(0xFF2E7D32),
    );

    return Card(
      color: palette.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: palette.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: 0.14),
          child: Icon(Icons.event_repeat_outlined, color: palette.accent),
        ),
        title: Text(
          scheduler.label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
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
    return localizedNoteTypeLabel(l10n, type, dependantGroup);
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

class _DetailCardPalette {
  const _DetailCardPalette({
    required this.background,
    required this.border,
    required this.accent,
  });

  final Color background;
  final Color border;
  final Color accent;
}
