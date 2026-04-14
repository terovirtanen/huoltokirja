import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../core/utils/text_normalization.dart';
import '../../../domain/models/dependant.dart';
import '../../../domain/models/note.dart';
import '../../../domain/models/scheduler.dart';
import '../../../domain/services/counter_estimator.dart';
import '../../../shared/widgets/centered_snackbar.dart';
import '../../notes/presentation/note_display_utils.dart';

class SchedulerEditorScreen extends ConsumerStatefulWidget {
  const SchedulerEditorScreen({
    super.key,
    required this.dependantId,
    this.schedulerId,
  });

  final int dependantId;
  final int? schedulerId;

  @override
  ConsumerState<SchedulerEditorScreen> createState() =>
      _SchedulerEditorScreenState();
}

enum _CalendarIntervalOption { none, yearly, semiAnnual, quarterly, custom }

class _SchedulerEditorScreenState extends ConsumerState<SchedulerEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _customMonthsController = TextEditingController();
  final _usageIntervalController = TextEditingController();
  final _usageStartController = TextEditingController();
  bool _loading = true;
  bool _usageRuleEnabled = false;
  bool _usageStartPrefilled = false;
  DateTime _startDate = DateTime.now();
  DateTime? _createdAt;
  NoteType _selectedNoteType = NoteType.plain;
  _CalendarIntervalOption _calendarIntervalOption =
      _CalendarIntervalOption.yearly;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    if (widget.schedulerId == null) {
      setState(() => _loading = false);
      return;
    }

    final existing = await ref
        .read(schedulerRepositoryProvider)
        .getById(widget.schedulerId!);
    if (existing == null) {
      if (mounted) context.pop();
      return;
    }

    _labelController.text = existing.label;
    _selectedNoteType = existing.noteType;
    _startDate = existing.startDate;
    _calendarIntervalOption = _optionFromMonths(
      existing.calendarIntervalMonths,
    );
    if (_calendarIntervalOption == _CalendarIntervalOption.custom &&
        existing.calendarIntervalMonths != null) {
      _customMonthsController.text = existing.calendarIntervalMonths.toString();
    }
    if (existing.usageInterval != null && existing.usageStartValue != null) {
      _usageRuleEnabled = true;
      _usageIntervalController.text = _formatNumber(existing.usageInterval!);
      _usageStartController.text = _formatNumber(existing.usageStartValue!);
      _usageStartPrefilled = true;
    }
    _createdAt = existing.createdAt;

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _customMonthsController.dispose();
    _usageIntervalController.dispose();
    _usageStartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = context.l10n;
    final detailAsync = ref.watch(dependantDetailProvider(widget.dependantId));
    final detail = detailAsync.valueOrNull;
    final dependant = detail?.dependant;
    final usageEstimate = dependant == null || detail == null
        ? null
        : estimateDependantUsage(dependant: dependant, notes: detail.notes);
    final latestUsage = dependant == null || detail == null
        ? null
        : latestRecordedUsage(dependant: dependant, notes: detail.notes);
    final visibleUsageEstimate =
        usageEstimate != null && dependant != null && detail != null
        ? (shouldShowUsageEstimate(
                dependant: dependant,
                estimate: usageEstimate,
                notes: detail.notes,
              )
              ? usageEstimate
              : null)
        : null;
    final dependantGroup = dependant?.dependantGroup ?? DependantGroup.none;
    final availableNoteTypes = availableNoteTypesForDependantGroup(
      dependantGroup,
    );
    final selectedNoteType = normalizeNoteTypeForDependantGroup(
      dependantGroup,
      _selectedNoteType,
    );
    final supportsUsage = dependant?.supportsUsage ?? false;
    final usageUnit = dependant?.usageUnit ?? '';

    if (supportsUsage && !_usageStartPrefilled) {
      final defaultUsage = latestUsage;
      if (defaultUsage != null) {
        _usageStartController.text = _formatNumber(defaultUsage);
      }
      _usageStartPrefilled = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.schedulerId == null
              ? l10n.addSchedulerTitle
              : l10n.editSchedulerTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _labelController,
              decoration: InputDecoration(labelText: l10n.name),
              textCapitalization: TextCapitalization.words,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.nameMissing
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NoteType>(
              initialValue: selectedNoteType,
              decoration: InputDecoration(labelText: l10n.type),
              items: availableNoteTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        localizedNoteTypeLabel(l10n, type, dependantGroup),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedNoteType = value);
                }
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.scheduleStartDate),
              subtitle: Text(context.formatDate(_startDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: _startDate,
                  );
                  if (picked != null) {
                    setState(() => _startDate = picked);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<_CalendarIntervalOption>(
              initialValue: _calendarIntervalOption,
              decoration: InputDecoration(labelText: l10n.calendarRule),
              items: [
                DropdownMenuItem(
                  value: _CalendarIntervalOption.none,
                  child: Text(l10n.noCalendarRule),
                ),
                DropdownMenuItem(
                  value: _CalendarIntervalOption.yearly,
                  child: Text(l10n.yearly),
                ),
                DropdownMenuItem(
                  value: _CalendarIntervalOption.semiAnnual,
                  child: Text(l10n.semiAnnual),
                ),
                DropdownMenuItem(
                  value: _CalendarIntervalOption.quarterly,
                  child: Text(l10n.quarterly),
                ),
                DropdownMenuItem(
                  value: _CalendarIntervalOption.custom,
                  child: Text(l10n.customMonths),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _calendarIntervalOption = value);
                }
              },
            ),
            if (_calendarIntervalOption == _CalendarIntervalOption.custom) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customMonthsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.customMonthsLabel),
                validator: (value) {
                  if (_calendarIntervalOption !=
                      _CalendarIntervalOption.custom) {
                    return null;
                  }
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return l10n.monthsMustBePositive;
                  }
                  return null;
                },
              ),
            ],
            if (supportsUsage) ...[
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.usageRule),
                subtitle: visibleUsageEstimate == null
                    ? null
                    : Text(
                        l10n.usageEstimateLine(
                          _formatNumber(visibleUsageEstimate.currentValue),
                          usageUnit,
                        ),
                      ),
                value: _usageRuleEnabled,
                onChanged: (value) => setState(() => _usageRuleEnabled = value),
              ),
              if (_usageRuleEnabled) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usageIntervalController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.usageIntervalLabel(usageUnit),
                  ),
                  validator: (value) {
                    if (!_usageRuleEnabled) {
                      return null;
                    }
                    final parsed = _parseDouble(value);
                    if (parsed == null || parsed <= 0) {
                      return l10n.intervalMustBePositive;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usageStartController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.usageStartValueLabel(usageUnit),
                  ),
                  validator: (value) {
                    if (!_usageRuleEnabled) {
                      return null;
                    }
                    return _parseDouble(value) == null
                        ? l10n.invalidNumber
                        : null;
                  },
                ),
              ],
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final calendarIntervalMonths = _selectedCalendarMonths();
    if (calendarIntervalMonths == null && !_usageRuleEnabled) {
      showCenteredSnackBar(context, context.l10n.scheduleRuleRequired);
      return;
    }

    final dependant = await ref
        .read(dependantRepositoryProvider)
        .getById(widget.dependantId);
    final selectedNoteType = normalizeNoteTypeForDependantGroup(
      dependant?.dependantGroup ?? DependantGroup.none,
      _selectedNoteType,
    );

    final now = DateTime.now();
    final scheduler = Scheduler(
      id: widget.schedulerId,
      dependantId: widget.dependantId,
      label: capitalizeFirst(_labelController.text),
      noteType: selectedNoteType,
      startDate: _startDate,
      calendarIntervalMonths: calendarIntervalMonths,
      usageInterval: _usageRuleEnabled
          ? _parseDouble(_usageIntervalController.text)
          : null,
      usageStartValue: _usageRuleEnabled
          ? _parseDouble(_usageStartController.text)
          : null,
      createdAt: _createdAt ?? now,
      updatedAt: now,
    );

    if (widget.schedulerId == null) {
      await ref.read(schedulerRepositoryProvider).create(scheduler);
    } else {
      await ref.read(schedulerRepositoryProvider).update(scheduler);
    }

    await ref
        .read(schedulerAutoTriggerServiceProvider)
        .triggerForDependant(widget.dependantId);

    ref.invalidate(dependantDetailProvider(widget.dependantId));
    ref.invalidate(allNotesFeedProvider);
    if (mounted) {
      showCenteredSnackBar(context, context.l10n.schedulerSaved);
      context.pop();
    }
  }

  _CalendarIntervalOption _optionFromMonths(int? months) {
    return switch (months) {
      null => _CalendarIntervalOption.none,
      12 => _CalendarIntervalOption.yearly,
      6 => _CalendarIntervalOption.semiAnnual,
      3 => _CalendarIntervalOption.quarterly,
      _ => _CalendarIntervalOption.custom,
    };
  }

  int? _selectedCalendarMonths() {
    return switch (_calendarIntervalOption) {
      _CalendarIntervalOption.none => null,
      _CalendarIntervalOption.yearly => 12,
      _CalendarIntervalOption.semiAnnual => 6,
      _CalendarIntervalOption.quarterly => 3,
      _CalendarIntervalOption.custom => int.tryParse(
        _customMonthsController.text.trim(),
      ),
    };
  }

  double? _parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }
}
