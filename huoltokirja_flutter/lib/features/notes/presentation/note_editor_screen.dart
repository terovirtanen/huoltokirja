import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Lisaa note' : 'Muokkaa notea'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<NoteType>(
              initialValue: _selectedType,
              items: const [
                DropdownMenuItem(
                  value: NoteType.service,
                  child: Text('Service note'),
                ),
                DropdownMenuItem(
                  value: NoteType.inspection,
                  child: Text('Inspection note'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedType = value);
              },
              decoration: const InputDecoration(labelText: 'Tyyppi'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Otsikko'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Otsikko on pakollinen'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Kuvaus'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            if (_selectedType == NoteType.service) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Service date'),
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
                decoration: const InputDecoration(
                  labelText: 'Counter estimate (optional)',
                ),
              ),
            ] else ...[
              TextFormField(
                controller: _inspectorNameController,
                decoration: const InputDecoration(
                  labelText: 'Tarkastaja (optional)',
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Tallenna')),
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
      ).showSnackBar(const SnackBar(content: Text('Note tallennettu')));
      context.pop();
    }
  }
}
