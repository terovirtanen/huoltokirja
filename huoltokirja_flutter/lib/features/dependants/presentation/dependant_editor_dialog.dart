import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/dependant.dart';

class DependantEditorDialog extends StatefulWidget {
  const DependantEditorDialog({super.key, this.initial});

  final Dependant? initial;

  @override
  State<DependantEditorDialog> createState() => _DependantEditorDialogState();
}

class _DependantEditorDialogState extends State<DependantEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _relationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _relationController = TextEditingController(
      text: widget.initial?.relation ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
        widget.initial == null ? l10n.newDependant : l10n.editDependant,
      ),
      content: Form(
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
              controller: _relationController,
              decoration: InputDecoration(labelText: l10n.relationOptional),
            ),
          ],
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
            final result = Dependant(
              id: widget.initial?.id,
              name: _nameController.text.trim(),
              relation: _relationController.text.trim().isEmpty
                  ? null
                  : _relationController.text.trim(),
              birthDate: widget.initial?.birthDate,
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
}
