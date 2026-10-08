import 'package:dailyquest/app/appearance_controller.dart';
import 'package:dailyquest/core/l10n/l10n.dart';
import 'package:dailyquest/core/theme/app_theme.dart';
import 'package:dailyquest/features/settings/theme_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/schemes.dart';

void main() {
  final registry = loadRegistryFromDisk();
  for (final brightness in Brightness.values) {
    for (final scheme in registry.schemes) {
      testWidgets('theme preview renders ${scheme.id} ${brightness.name}', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [themeRegistryProvider.overrideWithValue(registry)],
            child: MaterialApp(
              theme: AppTheme.build(scheme, brightness),
              locale: const Locale('zh'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: const ThemePreviewPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('主题预览'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
