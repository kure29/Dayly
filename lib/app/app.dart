import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/l10n.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/appearance.dart';
import '../features/settings/reminders.dart';
import '../widgets_bridge/widget_sync.dart';
import 'appearance_controller.dart';
import 'lifecycle.dart';
import 'router.dart';

class DailyQuestApp extends ConsumerWidget {
  const DailyQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = ref.watch(activeSchemeProvider);
    final mode = ref.watch(appearanceProvider.select((a) => a.mode));
    final router = ref.watch(routerProvider);
    ref.watch(reminderSyncProvider);
    ref.watch(widgetSnapshotSyncProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(scheme, Brightness.light),
      darkTheme: AppTheme.build(scheme, Brightness.dark),
      themeMode: mode.themeMode,
      routerConfig: router,
      builder: (context, child) =>
          AppLifecycleBinder(child: child ?? const SizedBox.shrink()),
      locale: null,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: resolveAppLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
