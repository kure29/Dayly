import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/appearance.dart';
import '../core/theme/scheme_definition.dart';
import '../core/theme/theme_registry.dart';

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

  final String schemeId;
  final int? customAccent;
  final BrightnessMode mode;

  AppearanceState copyWith({
    String? schemeId,
    int? customAccent,
    BrightnessMode? mode,
  }) => AppearanceState(
    schemeId: schemeId ?? this.schemeId,
    customAccent: customAccent ?? this.customAccent,
    mode: mode ?? this.mode,
  );

  @override
  bool operator ==(Object other) =>
      other is AppearanceState &&
      other.schemeId == schemeId &&
      other.customAccent == customAccent &&
      other.mode == mode;

  @override
  int get hashCode => Object.hash(schemeId, customAccent, mode);
}

/// Current appearance (scheme + brightness mode).
class AppearanceController extends Notifier<AppearanceState> {
  @override
  AppearanceState build() => const AppearanceState();

  void setScheme(String id) => state = state.copyWith(schemeId: id);

  void setCustomAccent(int argb) =>
      state = state.copyWith(schemeId: 'custom', customAccent: argb);

  void setMode(BrightnessMode mode) => state = state.copyWith(mode: mode);
}

final appearanceProvider =
    NotifierProvider<AppearanceController, AppearanceState>(
      AppearanceController.new,
    );

/// The resolved scheme for the current appearance.
final activeSchemeProvider = Provider<SchemeDefinition>((ref) {
  final registry = ref.watch(themeRegistryProvider);
  final a = ref.watch(appearanceProvider);
  return resolveScheme(registry, a.schemeId, a.customAccent);
});
