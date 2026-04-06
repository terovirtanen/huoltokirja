import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations_ext.dart';
import '../../../shared/widgets/state_widgets.dart';

class NotesPlaceholderScreen extends StatelessWidget {
  const NotesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: EmptyState(
        title: l10n.notesPlaceholderTitle,
        subtitle: l10n.notesPlaceholderSubtitle,
      ),
    );
  }
}
