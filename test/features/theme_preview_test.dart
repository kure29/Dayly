import 'package:dailyquest/features/settings/theme_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_env.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final scheme in testRegistry.schemes) {
      testWidgets('theme preview renders ${scheme.id} ${brightness.name}', (
        tester,
      ) async {
        final env = TestEnv();
        await pumpScreen(
          tester,
          env,
          const ThemePreviewPage(),
          brightness: brightness,
          scheme: scheme,
        );
        await tester.pumpAndSettle();
        expect(find.text('主题预览'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await unmountAndClose(tester, env);
      });
    }
  }
}
