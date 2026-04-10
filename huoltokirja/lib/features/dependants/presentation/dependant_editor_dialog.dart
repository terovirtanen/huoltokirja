import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/dependant.dart';
import '../../../domain/services/counter_estimator.dart';

class DependantEditorDialog extends ConsumerStatefulWidget {
  const DependantEditorDialog({super.key, this.initial});

  final Dependant? initial;

  @override
  ConsumerState<DependantEditorDialog> createState() =>
      _DependantEditorDialogState();
}

class _DependantEditorDialogState extends ConsumerState<DependantEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _tagController;
  late final TextEditingController _usageController;
  late DependantGroup _selectedGroup;
  DateTime? _initialDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _tagController = TextEditingController(text: widget.initial?.tag ?? '');
    _usageController = TextEditingController(
      text: widget.initial?.usage == null
          ? ''
          : _formatNumber(widget.initial!.usage!),
    );
    _selectedGroup = widget.initial?.dependantGroup ?? DependantGroup.none;
    _initialDate = widget.initial?.initialDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    _usageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usageEstimateAsync = widget.initial?.id == null
        ? null
        : ref.watch(dependantUsageEstimateProvider(widget.initial!.id!));

    return AlertDialog(
      title: Text(
        widget.initial == null ? l10n.newDependant : l10n.editDependant,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.name),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagController,
                decoration: InputDecoration(labelText: l10n.tagOptional),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DependantGroup>(
                initialValue: _selectedGroup,
                decoration: InputDecoration(labelText: l10n.group),
                items: DependantGroup.values
                    .map(
                      (group) => DropdownMenuItem(
                        value: group,
                        child: Text(_groupLabel(context, group)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: widget.initial == null
                    ? (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedGroup = value;
                          if (value == DependantGroup.none) {
                            _initialDate = null;
                          }
                          if (!value.supportsUsage) {
                            _usageController.clear();
                          }
                        });
                      }
                    : null,
              ),
              if (_selectedGroup != DependantGroup.none) ...[
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_initialDateLabel(context, _selectedGroup)),
                  subtitle: Text(
                    _initialDate == null
                        ? l10n.notSet
                        : context.formatDate(_initialDate!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        initialDate: _initialDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _initialDate = picked);
                      }
                    },
                  ),
                ),
              ],
              if (_selectedGroup.supportsUsage) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usageController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: _usageFieldLabel(context, _selectedGroup),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    return double.tryParse(value.trim().replaceAll(',', '.')) ==
                            null
                        ? l10n.invalidNumber
                        : null;
                  },
                ),
              ],
              if (usageEstimateAsync != null) ...[
                const SizedBox(height: 12),
                usageEstimateAsync.when(
                  data: (estimate) {
                    final initial = widget.initial;
                    if (estimate == null ||
                        initial == null ||
                        !shouldShowUsageEstimate(
                          dependant: initial,
                          estimate: estimate,
                        )) {
                      return const SizedBox.shrink();
                    }
                    final unit =
                        initial.usageUnit ?? _selectedGroup.usageUnit ?? '';
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.usageEstimateLine(
                          _formatNumber(estimate.currentValue),
                          unit,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final now = DateTime.now();
            final usageText = _usageController.text.trim().replaceAll(',', '.');
            final tagText = _tagController.text.trim();
            final result = Dependant(
              id: widget.initial?.id,
              name: _nameController.text.trim(),
              dependantGroup: widget.initial?.dependantGroup ?? _selectedGroup,
              initialDate: _selectedGroup == DependantGroup.none
                  ? null
                  : _initialDate,
              usage: _selectedGroup.supportsUsage && usageText.isNotEmpty
                  ? double.parse(usageText)
                  : null,
              tag: tagText.isEmpty ? null : tagText,
              createdAt: widget.initial?.createdAt ?? now,
              updatedAt: now,
            );
            Navigator.of(context).pop(result);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }

  String _groupLabel(BuildContext context, DependantGroup group) {
    final l10n = context.l10n;
    return switch (group) {
      DependantGroup.none => l10n.noGroup,
      DependantGroup.vehicle => l10n.vehicleGroup,
      DependantGroup.workMachine => l10n.workMachineGroup,
      DependantGroup.device => l10n.deviceGroup,
      DependantGroup.animal => l10n.animalGroup,
    };
  }

  String _initialDateLabel(BuildContext context, DependantGroup group) {
    return switch (group) {
      DependantGroup.none => context.l10n.noteDate,
      DependantGroup.animal => context.l10n.birthDateOptional,
      DependantGroup.vehicle ||
      DependantGroup.workMachine ||
      DependantGroup.device => context.l10n.commissioningDateOptional,
    };
  }

  String _usageFieldLabel(BuildContext context, DependantGroup group) {
    return switch (group) {
      DependantGroup.none => context.l10n.counterEstimateOptional,
      DependantGroup.vehicle => context.l10n.odometerOptional,
      DependantGroup.workMachine => context.l10n.operatingHoursOptional,
      DependantGroup.device ||
      DependantGroup.animal => context.l10n.counterEstimateOptional,
    };
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }
}
