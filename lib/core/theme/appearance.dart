import 'package:flutter/material.dart';

import 'custom_scheme.dart';
import 'scheme_definition.dart';
import 'theme_registry.dart';

/// User-selectable light/dark behavior. Stored by name.
enum BrightnessMode {
  system,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    BrightnessMode.system => ThemeMode.system,
    BrightnessMode.light => ThemeMode.light,
    BrightnessMode.dark => ThemeMode.dark,
  };

  static BrightnessMode parse(String? name) => BrightnessMode.values.firstWhere(
    (m) => m.name == name,
    orElse: () => BrightnessMode.system,
  );
}

/// Resolves the active [SchemeDefinition] for a scheme id and an optional
/// custom accent color (ARGB int).
SchemeDefinition resolveScheme(
  ThemeRegistry registry,
  String schemeId,
  int? customAccent,
) {
  if (schemeId == CustomSchemeGenerator.id && customAccent != null) {
    return CustomSchemeGenerator.generate(
      Color(customAccent),
      base: registry.fallback,
    );
  }
  return registry.resolve(schemeId);
}
