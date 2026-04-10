import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations_ext.dart';
import '../../../shared/widgets/state_widgets.dart';

class SchedulersPlaceholderScreen extends StatelessWidget {
  const SchedulersPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: EmptyState(
        title: l10n.schedulersPlaceholderTitle,
        subtitle: l10n.schedulersPlaceholderSubtitle,
      ),
    );
  }
}
