import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/l10n/app_localizations_ext.dart';
import '../../l10n/app_localizations.dart';

enum _AppMenuAction { exportCsv, exportPdf, changeLanguage }

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buttonContext) {
        return IconButton(
          icon: const Icon(Icons.menu),
          tooltip: buttonContext.l10n.menu,
          onPressed: () => Scaffold.maybeOf(buttonContext)?.openDrawer(),
        );
      },
    );
  }
}

class AppMenuDrawer extends ConsumerWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentLanguage = _currentLanguageLabel(
      l10n,
      ref.watch(appLocaleControllerProvider),
    );

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.menu,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.currentSelectionLabel(currentLanguage),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            _MenuActionTile(
              icon: Icons.table_chart_outlined,
              title: l10n.exportCsvAction,
              subtitle: l10n.exportCsvSubtitle,
              onTap: () async {
                await _runActionFromDrawer(
                  context,
                  ref,
                  _AppMenuAction.exportCsv,
                );
              },
            ),
            _MenuActionTile(
              icon: Icons.picture_as_pdf_outlined,
              title: l10n.exportPdfAction,
              subtitle: l10n.exportPdfSubtitle,
              onTap: () async {
                await _runActionFromDrawer(
                  context,
                  ref,
                  _AppMenuAction.exportPdf,
                );
              },
            ),
            _MenuActionTile(
              icon: Icons.language,
              title: l10n.changeLanguageAction,
              subtitle: l10n.currentSelectionLabel(currentLanguage),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await _runActionFromDrawer(
                  context,
                  ref,
                  _AppMenuAction.changeLanguage,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runActionFromDrawer(
    BuildContext context,
    WidgetRef ref,
    _AppMenuAction action,
  ) async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    Navigator.of(context).pop();
    await _handleAction(rootContext, ref, action);
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _AppMenuAction action,
  ) async {
    switch (action) {
      case _AppMenuAction.exportCsv:
        await _shareFile(
          context,
          createFile: () => ref.read(exportServiceProvider).exportCsv(),
          successMessage: (fileName) => context.l10n.csvExportReady(fileName),
        );
      case _AppMenuAction.exportPdf:
        await _shareFile(
          context,
          createFile: () => ref.read(exportServiceProvider).exportPdfReport(),
          successMessage: (fileName) => context.l10n.pdfExportReady(fileName),
        );
      case _AppMenuAction.changeLanguage:
        await _showLanguageDialog(context, ref);
    }
  }

  Future<void> _shareFile(
    BuildContext context, {
    required Future<File> Function() createFile,
    required String Function(String fileName) successMessage,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    try {
      final file = await createFile();
      final message = successMessage(file.uri.pathSegments.last);
      messenger.showSnackBar(SnackBar(content: Text(message)));
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: l10n.appTitle,
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportFailed(error.toString()))),
      );
    }
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final selectedLanguageCode =
        ref.read(appLocaleControllerProvider)?.languageCode ?? 'system';
    final controller = ref.read(appLocaleControllerProvider.notifier);
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.chooseLanguage),
          children: [
            _LanguageOption(
              label: l10n.useDeviceLanguage,
              selected: selectedLanguageCode == 'system',
              onTap: () async {
                await controller.useSystemLocale();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            _LanguageOption(
              label: l10n.finnishLanguage,
              selected: selectedLanguageCode == 'fi',
              onTap: () async {
                await controller.setLocale(const Locale('fi'));
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            _LanguageOption(
              label: l10n.englishLanguage,
              selected: selectedLanguageCode == 'en',
              onTap: () async {
                await controller.setLocale(const Locale('en'));
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _currentLanguageLabel(AppLocalizations l10n, Locale? locale) {
    return switch (locale?.languageCode) {
      'fi' => l10n.finnishLanguage,
      'en' => l10n.englishLanguage,
      _ => l10n.useDeviceLanguage,
    };
  }
}

class _MenuActionTile extends StatelessWidget {
  const _MenuActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: () {
        onTap();
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        onTap();
      },
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (selected)
            Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
