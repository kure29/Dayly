import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/appearance_controller.dart';
import 'core/theme/theme_registry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final registry = await ThemeRegistry.loadFromAssets();
  runApp(
    ProviderScope(
      overrides: [themeRegistryProvider.overrideWithValue(registry)],
      child: const DailyQuestApp(),
    ),
  );
}
