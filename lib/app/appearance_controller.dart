import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/appearance.dart';
import '../core/theme/scheme_definition.dart';
import '../core/theme/theme_registry.dart';
import '../domain/models.dart';
import 'providers.dart';

/// Overridden in `main()` with the registry loaded from assets.
final themeRegistryProvider = Provider<ThemeRegistry>(
  (ref) => throw UnimplementedError('themeRegistryProvider must be overridden'),
);

@immutable
class AppearanceState {
  const AppearanceState({
    this.schemeId = ThemeRegistry.defaultSchemeId,
    this.customAccent,
    this.mode = BrightnessMode.system,
  });

  factory AppearanceState.fromSettings(AppSettings s) => AppearanceState(
    schemeId: s.schemeId,
    customAccent: s.customAccent,
    mode: s.brightnessMode,
  );

  final String schemeId;
  final int? customAccent;
  final BrightnessMode mode;

  @override
  bool operator ==(Object other) =>
      other is AppearanceState &&
      other.schemeId == schemeId &&
      other.customAccent == customAccent &&
      other.mode == mode;

  @override
  int get hashCode => Object.hash(schemeId, customAccent, mode);
}

/// Current appearance, derived from persisted settings.
final appearanceProvider = Provider<AppearanceState>((ref) {
  final settings = ref.watch(settingsProvider).value;
  return settings == null
      ? const AppearanceState()
      : AppearanceState.fromSettings(settings);
});

/// The resolved scheme for the current appearance.
final activeSchemeProvider = Provider<SchemeDefinition>((ref) {
  final registry = ref.watch(themeRegistryProvider);
  final a = ref.watch(appearanceProvider);
  return resolveScheme(registry, a.schemeId, a.customAccent);
});

/// Writes settings and profile changes.
class SettingsController {
  SettingsController(this._ref);

  final Ref _ref;

  Future<void> update(AppSettings Function(AppSettings current) change) async {
    final repo = _ref.read(settingsRepositoryProvider);
    await repo.saveSettings(change(await repo.loadSettings()));
  }

  Future<void> updateProfile(Profile Function(Profile current) change) async {
    final repo = _ref.read(settingsRepositoryProvider);
    await repo.saveProfile(change(await repo.loadProfile()));
  }

  Future<void> setScheme(String id) => update((s) => s.copyWith(schemeId: id));

  Future<void> setCustomAccent(int argb) =>
      update((s) => s.copyWith(schemeId: 'custom', customAccent: () => argb));

  Future<void> setMode(BrightnessMode mode) =>
      update((s) => s.copyWith(brightnessMode: mode));
}

final settingsControllerProvider = Provider<SettingsController>(
  SettingsController.new,
);
