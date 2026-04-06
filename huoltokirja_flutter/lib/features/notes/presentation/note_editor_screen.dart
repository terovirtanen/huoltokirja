import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/note.dart';

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
  final _inspectorNameController = TextEditingController();
  NoteType _selectedType = NoteType.service;
  DateTime _serviceDate = DateTime.now();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
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
    switch (existing) {
      case ServiceNote service:
        _selectedType = NoteType.service;
        _serviceDate = service.serviceDate;
        _serviceCounterController.text =
            service.estimatedCounter?.toString() ?? '';
      case InspectionNote inspection:
        _selectedType = NoteType.inspection;
        _inspectorNameController.text = inspection.inspectorName ?? '';
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _serviceCounterController.dispose();
    _inspectorNameController.dispose();
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
                  value: NoteType.service,
                  child: Text(l10n.serviceNote),
                ),
                DropdownMenuItem(
                  value: NoteType.inspection,
                  child: Text(l10n.inspectionNote),
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
            if (_selectedType == NoteType.service) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.serviceDate),
                subtitle: Text(_serviceDate.toIso8601String().split('T').first),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: _serviceDate,
                    );
                    if (picked != null) {
                      setState(() => _serviceDate = picked);
                    }
                  },
                ),
              ),
              TextFormField(
                controller: _serviceCounterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.counterEstimateOptional,
                ),
              ),
            ] else ...[
              TextFormField(
                controller: _inspectorNameController,
                decoration: InputDecoration(labelText: l10n.inspectorOptional),
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
    final note = switch (_selectedType) {
      NoteType.service => ServiceNote(
        id: widget.noteId,
        dependantId: widget.dependantId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        serviceDate: _serviceDate,
        estimatedCounter: int.tryParse(_serviceCounterController.text.trim()),
        createdAt: now,
        updatedAt: now,
      ),
      NoteType.inspection => InspectionNote(
        id: widget.noteId,
        dependantId: widget.dependantId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        inspectorName: _inspectorNameController.text.trim().isEmpty
            ? null
            : _inspectorNameController.text.trim(),
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
      final updatedNote = switch (note) {
        ServiceNote service => ServiceNote(
          id: widget.noteId,
          dependantId: widget.dependantId,
          title: service.title,
          body: service.body,
          serviceDate: service.serviceDate,
          estimatedCounter: service.estimatedCounter,
          createdAt: existing.createdAt,
          updatedAt: now,
        ),
        InspectionNote inspection => InspectionNote(
          id: widget.noteId,
          dependantId: widget.dependantId,
          title: inspection.title,
          body: inspection.body,
          inspectorName: inspection.inspectorName,
          createdAt: existing.createdAt,
          updatedAt: now,
        ),
      };
      await ref.read(noteRepositoryProvider).update(updatedNote);
    }

    ref.invalidate(dependantDetailProvider(widget.dependantId));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.noteSaved)));
      context.pop();
    }
  }
}
