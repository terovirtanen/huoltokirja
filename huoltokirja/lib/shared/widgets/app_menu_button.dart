import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/config/app_config.dart';
import '../../core/l10n/app_localizations_ext.dart';
import '../../data/services/backup_service.dart';
import '../../l10n/app_localizations.dart';
import 'centered_snackbar.dart';

Rect _fallbackShareOrigin(BuildContext context) {
  final screenSize = MediaQuery.sizeOf(context);
  return Rect.fromCenter(
    center: Offset(screenSize.width / 2, screenSize.height / 2),
    width: 1,
    height: 1,
  );
}

Rect _resolveShareOrigin(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is RenderBox && renderObject.hasSize) {
    final size = renderObject.size;
    if (size.width > 0 && size.height > 0) {
      return renderObject.localToGlobal(Offset.zero) & size;
    }
  }

  return _fallbackShareOrigin(context);
}

enum _AppMenuAction {
  sortTargets,
  backupMenu,
  toggleCloudBackupSync,
  chooseCloudBackupFolder,
  exportBackup,
  importBackup,
  exportCsv,
  exportPdf,
  changeLanguage,
  about,
}

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
  const AppMenuDrawer({super.key, this.selectedTags = const <String>{}});

  final Set<String> selectedTags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sortOrder = ref.watch(dependantSortOrderProvider);
    final currentLanguage = _currentLanguageLabel(
      l10n,
      ref.watch(appLocaleControllerProvider),
    );
    final currentSortLabel = _sortOrderLabel(l10n, sortOrder);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.menu,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.currentSelectionLabel(currentLanguage),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            _MenuActionTile(
              icon: Icons.sort,
              title: l10n.targetSortAction,
              subtitle: l10n.currentSelectionLabel(currentSortLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await _runActionFromDrawer(
                  context,
                  _AppMenuAction.sortTargets,
                );
              },
            ),
            _MenuActionTile(
              icon: Icons.backup_outlined,
              title: l10n.backupMenuAction,
              subtitle: l10n.backupMenuSubtitle,
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await _runActionFromDrawer(
                  context,
                  _AppMenuAction.backupMenu,
                );
              },
            ),
            _MenuActionTile(
              icon: Icons.table_chart_outlined,
              title: l10n.exportCsvAction,
              subtitle: l10n.exportCsvSubtitle,
              onTap: () async {
                await _runActionFromDrawer(
                  context,
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
                  _AppMenuAction.changeLanguage,
                );
              },
            ),
            const Divider(height: 1),
            _MenuActionTile(
              icon: Icons.info_outline,
              title: l10n.aboutAction,
              onTap: () async {
                await _runActionFromDrawer(context, _AppMenuAction.about);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runActionFromDrawer(
    BuildContext context,
    _AppMenuAction action,
  ) async {
    final shareOrigin = _resolveShareOrigin(context);
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final container = ProviderScope.containerOf(rootContext, listen: false);
    Navigator.of(context).pop();
    await _handleAction(
      rootContext,
      container,
      action,
      shareOrigin: shareOrigin,
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    ProviderContainer container,
    _AppMenuAction action, {
    Rect? shareOrigin,
  }
  ) async {
    switch (action) {
      case _AppMenuAction.sortTargets:
        await _showSortDialog(context, container);
      case _AppMenuAction.backupMenu:
        await _showBackupMenu(context, container);
      case _AppMenuAction.toggleCloudBackupSync:
        await _toggleCloudBackupSync(context, container);
      case _AppMenuAction.chooseCloudBackupFolder:
        await _chooseCloudBackupFolder(context, container);
      case _AppMenuAction.exportBackup:
        await _exportBackup(context, container);
      case _AppMenuAction.importBackup:
        await _restoreBackup(context, container);
      case _AppMenuAction.exportCsv:
        await _shareFile(
          context,
          createFile: () => container
              .read(exportServiceProvider)
              .exportCsv(
                selectedTags: selectedTags,
                localeName: context.l10n.localeName,
              ),
          successMessage: (fileName) => context.l10n.csvExportReady(fileName),
          shareOrigin: shareOrigin,
        );
      case _AppMenuAction.exportPdf:
        await _shareFile(
          context,
          createFile: () => container
              .read(exportServiceProvider)
              .exportPdfReport(
                selectedTags: selectedTags,
                l10n: context.l10n,
                materialLocalizations: MaterialLocalizations.of(context),
              ),
          successMessage: (fileName) => context.l10n.pdfExportReady(fileName),
          shareOrigin: shareOrigin,
        );
      case _AppMenuAction.changeLanguage:
        await _showLanguageDialog(context, container);
      case _AppMenuAction.about:
        await _showAboutDialog(context);
    }
  }

  Future<void> _showBackupMenu(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final l10n = context.l10n;
    final cloudSyncEnabled = container.read(backupCloudSyncEnabledProvider);
    final cloudDirectoryPath = container.read(backupCloudDirectoryPathProvider);
    final cloudFolderLabel = cloudDirectoryPath == null
        ? l10n.backupCloudFolderNotSet
        : p.basename(cloudDirectoryPath);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.backupMenuAction),
          children: [
            _BackupMenuOption(
              icon: Icons.cloud_sync_outlined,
              title: l10n.backupCloudSyncAction,
              subtitle: l10n.currentSelectionLabel(
                cloudSyncEnabled
                    ? l10n.backupCloudSyncEnabled
                    : l10n.backupCloudSyncDisabled,
              ),
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await _toggleCloudBackupSync(context, container);
              },
            ),
            _BackupMenuOption(
              icon: Icons.folder_open,
              title: l10n.backupCloudFolderAction,
              subtitle: l10n.currentSelectionLabel(cloudFolderLabel),
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await _chooseCloudBackupFolder(context, container);
              },
            ),
            _BackupMenuOption(
              icon: Icons.upload_file,
              title: l10n.exportBackupAction,
              subtitle: l10n.exportBackupSubtitle,
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await _exportBackup(context, container);
              },
            ),
            _BackupMenuOption(
              icon: Icons.restore_page_outlined,
              title: l10n.importBackupAction,
              subtitle: l10n.importBackupSubtitle,
              onTap: () async {
                Navigator.of(dialogContext).pop();
                await _restoreBackup(context, container);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportBackup(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final l10n = context.l10n;
    final backupService = container.read(backupServiceProvider);
    final cloudSyncEnabled = container.read(backupCloudSyncEnabledProvider);
    final cloudDirectoryPath = container.read(backupCloudDirectoryPathProvider);

    try {
      final localBackup = await backupService.createAutomaticBackup();

      if (cloudSyncEnabled &&
          (cloudDirectoryPath == null || cloudDirectoryPath.isEmpty)) {
        showCenteredSnackBar(
          context,
          l10n.backupSavedToDeviceCloudFolderMissing(
            localBackup.uri.pathSegments.last,
          ),
        );
        return;
      }

      final successMessage = cloudSyncEnabled
          ? l10n.backupSavedToDeviceCloudSyncOnClose(
              localBackup.uri.pathSegments.last,
            )
          : l10n.backupSavedToDevice(localBackup.uri.pathSegments.last);
      showCenteredSnackBar(context, successMessage);
    } catch (error) {
      showCenteredSnackBar(context, l10n.exportFailed(error.toString()));
    }
  }

  Future<void> _toggleCloudBackupSync(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final controller = container.read(backupCloudSyncEnabledProvider.notifier);
    final nextValue = !container.read(backupCloudSyncEnabledProvider);
    await controller.setEnabled(nextValue);

    final l10n = context.l10n;
    showCenteredSnackBar(
      context,
      nextValue ? l10n.backupCloudSyncOn : l10n.backupCloudSyncOff,
    );

    if (nextValue &&
        (container.read(backupCloudDirectoryPathProvider) == null ||
            container.read(backupCloudDirectoryPathProvider)!.isEmpty)) {
      await _chooseCloudBackupFolder(context, container);
    }
  }

  Future<void> _chooseCloudBackupFolder(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final l10n = context.l10n;
    final controller = container.read(backupCloudDirectoryPathProvider.notifier);

    try {
      String? selectedPath;
      try {
        final saveLocation = await getSaveLocation(
          suggestedName: 'huoltokirja-cloud-placeholder.json',
          acceptedTypeGroups: const [
            XTypeGroup(
              label: 'json',
              extensions: ['json'],
              uniformTypeIdentifiers: ['public.json'],
            ),
          ],
          confirmButtonText: l10n.backupCloudFolderAction,
        );
        selectedPath = saveLocation?.path;
      } on UnimplementedError {
        // Fallback for platforms where save location picking is not supported.
        final selectedFile = await openFile(
          acceptedTypeGroups: const [
            XTypeGroup(
              label: 'json',
              extensions: ['json'],
              uniformTypeIdentifiers: ['public.json'],
            ),
          ],
          confirmButtonText: l10n.backupCloudFolderAction,
        );
        selectedPath = selectedFile?.path;
      }

      if (selectedPath == null || selectedPath.isEmpty) {
        return;
      }

      final cloudDirectoryPath = p.dirname(selectedPath);
      if (cloudDirectoryPath.isEmpty) {
        showCenteredSnackBar(context, l10n.backupCloudFolderNotSet);
        return;
      }

      await controller.setPath(cloudDirectoryPath);
      showCenteredSnackBar(
        context,
        l10n.backupCloudFolderSet(p.basename(cloudDirectoryPath)),
      );
    } catch (error) {
      showCenteredSnackBar(
        context,
        l10n.backupCloudFolderSetFailed(error.toString()),
      );
    }
  }

  Future<void> _shareFile(
    BuildContext context, {
    required Future<File> Function() createFile,
    required String Function(String fileName) successMessage,
    Rect? shareOrigin,
  }) async {
    final l10n = context.l10n;

    try {
      final file = await createFile();
      final message = successMessage(file.uri.pathSegments.last);
      showCenteredSnackBar(context, message);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: l10n.appTitle,
        sharePositionOrigin: shareOrigin ?? _fallbackShareOrigin(context),
      );
    } catch (error) {
      showCenteredSnackBar(context, l10n.exportFailed(error.toString()));
    }
  }

  Future<void> _restoreBackup(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final l10n = context.l10n;
    final backupService = container.read(backupServiceProvider);
    final cloudDirectoryPath = container.read(backupCloudDirectoryPathProvider);

    try {
      final versions = await backupService.listRestorableBackups(
        cloudDirectoryPath: cloudDirectoryPath,
      );
      if (versions.isEmpty) {
        showCenteredSnackBar(context, l10n.backupRestoreNoBackupFound);
        return;
      }

      final selected = await _showBackupVersionPicker(context, versions);
      if (selected == null) {
        return;
      }

      await backupService.restoreFromFile(selected.file);

      container.invalidate(dependantListControllerProvider);
      container.invalidate(allNotesFeedProvider);

      showCenteredSnackBar(context, l10n.backupRestoreSuccess);
    } catch (error) {
      showCenteredSnackBar(
        context,
        l10n.backupRestoreFailed(error.toString()),
      );
    }
  }

  Future<BackupVersion?> _showBackupVersionPicker(
    BuildContext context,
    List<BackupVersion> versions,
  ) async {
    final l10n = context.l10n;
    BackupVersion selected = versions.first;

    return showDialog<BackupVersion>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.backupVersionPickerTitle),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final version in versions)
                        RadioListTile<BackupVersion>(
                          value: version,
                          groupValue: selected,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selected = value;
                              });
                            }
                          },
                          title: Text(_backupVersionLabel(context, version)),
                          subtitle: Text(
                            version.source == BackupSource.cloud
                                ? l10n.backupSourceCloud
                                : l10n.backupSourceDevice,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(selected),
                  child: Text(l10n.importBackupAction),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _backupVersionLabel(BuildContext context, BackupVersion version) {
    final localizations = MaterialLocalizations.of(context);
    final date = localizations.formatShortDate(version.modifiedAt);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(version.modifiedAt),
      alwaysUse24HourFormat: true,
    );
    return '$date $time - ${version.fileName}';
  }

  Future<void> _showLanguageDialog(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final selectedLanguageCode =
        container.read(appLocaleControllerProvider)?.languageCode ?? 'system';
    final controller = container.read(appLocaleControllerProvider.notifier);
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

  Future<void> _showSortDialog(
    BuildContext context,
    ProviderContainer container,
  ) async {
    final controller = container.read(dependantSortOrderProvider.notifier);
    final selectedOrder = container.read(dependantSortOrderProvider);
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.targetSortAction),
          children: [
            _SortOption(
              label: l10n.targetSortLatestNote,
              selected: selectedOrder == DependantSortOrder.latestNote,
              onTap: () async {
                await controller.setSortOrder(DependantSortOrder.latestNote);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            _SortOption(
              label: l10n.targetSortName,
              selected: selectedOrder == DependantSortOrder.name,
              onTap: () async {
                await controller.setSortOrder(DependantSortOrder.name);
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

  Future<void> _showAboutDialog(BuildContext context) async {
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.aboutAction),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: Theme.of(dialogContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(l10n.versionValue(AppConfig.appVersion)),
              const SizedBox(height: 4),
              Text(l10n.buildDateValue(AppConfig.appBuildDate)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
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

  String _sortOrderLabel(AppLocalizations l10n, DependantSortOrder order) {
    return switch (order) {
      DependantSortOrder.latestNote => l10n.targetSortLatestNote,
      DependantSortOrder.name => l10n.targetSortName,
    };
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}

class _BackupMenuOption extends StatelessWidget {
  const _BackupMenuOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        onTap();
      },
    );
  }
}

class _MenuActionTile extends StatelessWidget {
  const _MenuActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Future<void> Function() onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
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
