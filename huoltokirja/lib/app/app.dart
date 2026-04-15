import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class HuoltokirjaApp extends ConsumerStatefulWidget {
  const HuoltokirjaApp({super.key});

  @override
  ConsumerState<HuoltokirjaApp> createState() => _HuoltokirjaAppState();
}

class _HuoltokirjaAppState extends ConsumerState<HuoltokirjaApp>
    with WidgetsBindingObserver {
  static const _initialCloudRestoreCheckKey =
      'backup_initial_cloud_restore_check_done';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkCloudRestoreOnFirstInstall());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_syncBackupToCloudOnExit());
    }
  }

  Future<void> _syncBackupToCloudOnExit() async {
    final backupService = ref.read(backupServiceProvider);
    await backupService.flushPendingAutomaticBackup();

    final cloudSyncEnabled = ref.read(backupCloudSyncEnabledProvider);
    final cloudDirectoryPath = ref.read(backupCloudDirectoryPathProvider);
    await backupService.syncLatestBackupToCloud(
      enabled: cloudSyncEnabled,
      cloudDirectoryPath: cloudDirectoryPath,
    );
  }

  Future<void> _checkCloudRestoreOnFirstInstall() async {
    final preferences = await SharedPreferences.getInstance();
    final alreadyChecked =
        preferences.getBool(_initialCloudRestoreCheckKey) ?? false;
    if (alreadyChecked) {
      return;
    }

    await preferences.setBool(_initialCloudRestoreCheckKey, true);

    final cloudDirectoryPath = ref.read(backupCloudDirectoryPathProvider);
    if (!mounted || cloudDirectoryPath == null || cloudDirectoryPath.isEmpty) {
      return;
    }

    final backupService = ref.read(backupServiceProvider);
    final cloudVersions = await backupService.listCloudBackups(
      cloudDirectoryPath: cloudDirectoryPath,
    );

    if (!mounted || cloudVersions.isEmpty) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    }

    final shouldRestore =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(l10n.cloudBackupFoundTitle),
              content: Text(l10n.cloudBackupFoundBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(l10n.importBackupAction),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!mounted || !shouldRestore) {
      return;
    }

    try {
      await backupService.restoreFromFile(cloudVersions.first.file);
      ref.invalidate(dependantListControllerProvider);
      ref.invalidate(allNotesFeedProvider);
    } catch (_) {
      // Startup should continue even if restoring the found cloud backup fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
    );
  }
}
