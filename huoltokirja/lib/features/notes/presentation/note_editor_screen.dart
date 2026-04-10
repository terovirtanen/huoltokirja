import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/dependant.dart';
import '../../../domain/models/note.dart';
import 'note_display_utils.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, required this.dependantId, this.noteId});

  final int dependantId;
  final int? noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _serviceCounterController = TextEditingController();
  final _performerController = TextEditingController();
  final _priceController = TextEditingController();
  NoteType _selectedType = NoteType.plain;
  DateTime _noteDate = DateTime.now();
  bool _isApproved = false;
  bool _loading = true;
  DependantGroup _dependantGroup = DependantGroup.none;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final dependant = await ref
        .read(dependantRepositoryProvider)
        .getById(widget.dependantId);
    _dependantGroup = dependant?.dependantGroup ?? DependantGroup.none;

    if (widget.noteId == null) {
      setState(() => _loading = false);
      return;
    }

    final existing = await ref
        .read(noteRepositoryProvider)
        .getById(widget.noteId!);
    if (existing == null) {
      if (mounted) context.pop();
      return;
    }

    _titleController.text = existing.title;
    _bodyController.text = existing.body;
    _selectedType = existing.type;
    _noteDate = existing.noteDate;
    _serviceCounterController.text =
        existing.estimatedCounter?.toString() ?? '';
    _performerController.text = existing.performerName ?? '';
    _priceController.text = existing.price?.toString() ?? '';
    _isApproved = existing.isApproved;

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _serviceCounterController.dispose();
    _performerController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = context.l10n;
    final showCounterField = shouldShowCounterField(
      dependantGroup: _dependantGroup,
      noteType: _selectedType,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteId == null ? l10n.addNoteTitle : l10n.editNoteTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<NoteType>(
              initialValue: _selectedType,
              items: [
                DropdownMenuItem(
                  value: NoteType.plain,
                  child: Text(
                    localizedNoteTypeLabel(
                      l10n,
                      NoteType.plain,
                      _dependantGroup,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: NoteType.service,
                  child: Text(
                    localizedNoteTypeLabel(
                      l10n,
                      NoteType.service,
                      _dependantGroup,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: NoteType.inspection,
                  child: Text(
                    localizedNoteTypeLabel(
                      l10n,
                      NoteType.inspection,
                      _dependantGroup,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedType = value);
              },
              decoration: InputDecoration(labelText: l10n.type),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.title),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.titleRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: l10n.description),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.noteDate),
              subtitle: Text(context.formatDate(_noteDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: _noteDate,
                  );
                  if (picked != null) {
                    setState(() => _noteDate = picked);
                  }
                },
              ),
            ),
            if (_selectedType == NoteType.service ||
                _selectedType == NoteType.inspection) ...[
              if (showCounterField) ...[
                TextFormField(
                  controller: _serviceCounterController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.counterEstimateOptional,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _performerController,
                decoration: InputDecoration(labelText: l10n.inspectorOptional),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l10n.priceOptional),
              ),
              if (_selectedType == NoteType.inspection)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isApproved,
                  onChanged: (value) {
                    setState(() => _isApproved = value ?? false);
                  },
                  title: Text(l10n.approvedLabel),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
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

    final now = DateTime.now();
    final estimatedCounter =
        shouldShowCounterField(
          dependantGroup: _dependantGroup,
          noteType: _selectedType,
        )
        ? int.tryParse(_serviceCounterController.text.trim())
        : null;

    final note = switch (_selectedType) {
      NoteType.plain => PlainNote(
        id: widget.noteId,
        dependantId: widget.dependantId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        noteDate: _noteDate,
        createdAt: now,
        updatedAt: now,
      ),
      NoteType.service => ServiceNote(
        id: widget.noteId,
        dependantId: widget.dependantId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        serviceDate: _noteDate,
        estimatedCounter: estimatedCounter,
        performerName: _performerController.text.trim().isEmpty
            ? null
            : _performerController.text.trim(),
        price: double.tryParse(
          _priceController.text.trim().replaceAll(',', '.'),
        ),
        createdAt: now,
        updatedAt: now,
      ),
      NoteType.inspection => InspectionNote(
        id: widget.noteId,
        dependantId: widget.dependantId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        noteDate: _noteDate,
        estimatedCounter: estimatedCounter,
        performerName: _performerController.text.trim().isEmpty
            ? null
            : _performerController.text.trim(),
        price: double.tryParse(
          _priceController.text.trim().replaceAll(',', '.'),
        ),
        isApproved: _isApproved,
        createdAt: now,
        updatedAt: now,
      ),
    };

    if (widget.noteId == null) {
      await ref.read(noteRepositoryProvider).create(note);
    } else {
      final existing = await ref
          .read(noteRepositoryProvider)
          .getById(widget.noteId!);
      if (existing == null) return;
      final didUserChange = hasMeaningfulNoteChanges(existing, note);
      final updatedNote = switch (note) {
        PlainNote plain => PlainNote(
          id: widget.noteId,
          schedulerId: existing.schedulerId,
          schedulerTriggerKey: existing.schedulerTriggerKey,
          isUserModified: existing.isUserModified || didUserChange,
          dependantId: widget.dependantId,
          title: plain.title,
          body: plain.body,
          noteDate: plain.noteDate,
          createdAt: existing.createdAt,
          updatedAt: now,
        ),
        ServiceNote service => ServiceNote(
          id: widget.noteId,
          schedulerId: existing.schedulerId,
          schedulerTriggerKey: existing.schedulerTriggerKey,
          isUserModified: existing.isUserModified || didUserChange,
          dependantId: widget.dependantId,
          title: service.title,
          body: service.body,
          serviceDate: service.serviceDate,
          estimatedCounter: service.estimatedCounter,
          performerName: service.performerName,
          price: service.price,
          createdAt: existing.createdAt,
          updatedAt: now,
        ),
        InspectionNote inspection => InspectionNote(
          id: widget.noteId,
          schedulerId: existing.schedulerId,
          schedulerTriggerKey: existing.schedulerTriggerKey,
          isUserModified: existing.isUserModified || didUserChange,
          dependantId: widget.dependantId,
          title: inspection.title,
          body: inspection.body,
          noteDate: inspection.noteDate,
          estimatedCounter: inspection.estimatedCounter,
          performerName: inspection.performerName,
          price: inspection.price,
          isApproved: inspection.isApproved,
          createdAt: existing.createdAt,
          updatedAt: now,
        ),
      };
      await ref.read(noteRepositoryProvider).update(updatedNote);
    }

    await ref
        .read(schedulerAutoTriggerServiceProvider)
        .triggerForDependant(widget.dependantId);

    ref.invalidate(dependantDetailProvider(widget.dependantId));
    ref.invalidate(allNotesFeedProvider);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.noteSaved)));
      context.pop();
    }
  }
}
