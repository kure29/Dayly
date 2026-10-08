import 'package:dailyquest/app/appearance_controller.dart';
import 'package:dailyquest/app/providers.dart';
import 'package:dailyquest/core/l10n/l10n.dart';
import 'package:dailyquest/core/theme/app_theme.dart';
import 'package:dailyquest/core/theme/scheme_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'schemes.dart';
import 'test_env.dart';

final testRegistry = loadRegistryFromDisk();

/// Provider overrides wiring the app to [env]'s in-memory database.
List<Override> envOverrides(TestEnv env) => [
  themeRegistryProvider.overrideWithValue(testRegistry),
  databaseProvider.overrideWithValue(env.db),
  clockProvider.overrideWithValue(env.clock.call),
];

/// Phone-sized viewport.
void usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Pumps [home] inside a themed, localized MaterialApp.
Future<void> pumpScreen(
  WidgetTester tester,
  TestEnv env,
  Widget home, {
  Brightness brightness = Brightness.light,
  SchemeDefinition? scheme,
  List<Override> overrides = const [],
}) async {
  usePhoneViewport(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [...envOverrides(env), ...overrides],
      child: MaterialApp(
        theme: AppTheme.build(scheme ?? testRegistry.fallback, brightness),
        locale: const Locale('zh'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: home,
      ),
    ),
  );
}

/// Unmounts the tree (cancelling drift query streams) and flushes the
/// zero-duration timers drift schedules on cancel, then closes the db.
Future<void> unmountAndClose(WidgetTester tester, TestEnv env) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 10));
  await tester.runAsync(env.dispose);
}
