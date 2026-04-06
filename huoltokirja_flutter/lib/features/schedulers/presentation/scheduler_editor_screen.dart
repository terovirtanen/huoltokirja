import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/scheduler.dart';

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

class _SchedulerEditorScreenState extends ConsumerState<SchedulerEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _intervalController = TextEditingController(text: '30');
  DateTime? _lastCompletedAt;
  bool _loading = true;
  DateTime? _createdAt;

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
    _intervalController.text = existing.intervalDays.toString();
    _lastCompletedAt = existing.lastCompletedAt;
    _createdAt = existing.createdAt;

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = context.l10n;

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
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.nameMissing
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.intervalDays),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return l10n.intervalMustBePositive;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.lastCompletedOptional),
              subtitle: Text(
                _lastCompletedAt == null
                    ? l10n.notSet
                    : _lastCompletedAt!.toIso8601String().split('T').first,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: _lastCompletedAt ?? DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _lastCompletedAt = picked);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final scheduler = Scheduler(
      id: widget.schedulerId,
      dependantId: widget.dependantId,
      label: _labelController.text.trim(),
      intervalDays: int.parse(_intervalController.text.trim()),
      lastCompletedAt: _lastCompletedAt,
      createdAt: _createdAt ?? now,
      updatedAt: now,
    );

    if (widget.schedulerId == null) {
      await ref.read(schedulerRepositoryProvider).create(scheduler);
    } else {
      await ref.read(schedulerRepositoryProvider).update(scheduler);
    }

    ref.invalidate(dependantDetailProvider(widget.dependantId));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.schedulerSaved)));
      context.pop();
    }
  }
}
