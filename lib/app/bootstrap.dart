import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../core/l10n/l10n.dart';
import '../core/theme/theme_registry.dart';
import '../features/task_editor/builtin_templates.dart';
import 'appearance_controller.dart';
import 'providers.dart';

/// Loads everything the first frame needs (theme registry, settings) and
/// writes first-launch sample data, so the app never flashes defaults.
Future<ProviderContainer> bootstrap({
  List<Override> overrides = const [],
}) async {
  final registry = await ThemeRegistry.loadFromAssets();
  final container = ProviderContainer(
    overrides: [
      themeRegistryProvider.overrideWithValue(registry),
      ...overrides,
    ],
  );
  final locale = resolveAppLocale(
    PlatformDispatcher.instance.locale,
    AppLocalizations.supportedLocales,
  );
  final l10n = lookupAppLocalizations(locale);
  final service = container.read(taskServiceProvider);
  await service.seedIfNeeded(buildSeedContent(l10n, service.now()));
  await container.read(settingsProvider.future);
  return container;
}
