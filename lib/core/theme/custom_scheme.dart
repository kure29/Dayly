import 'dart:ui';

import 'color_utils.dart';
import 'design_tokens.dart';
import 'scheme_definition.dart';

/// Builds a full [SchemeDefinition] from a single user-picked accent color.
///
/// The light variant is darkened and the dark variant lightened (in HSL) just
/// enough to keep accent-colored text ≥ 4.5:1 on cards — including on the
/// tinted capsule-button background — and the ring ≥ 3:1.
abstract final class CustomSchemeGenerator {
  static const String id = 'custom';

  static SchemeDefinition generate(
    Color seed, {
    required SchemeDefinition base,
  }) {
    return SchemeDefinition(
      id: id,
      names: const {'zh': '自定义', 'en': 'Custom'},
      order: 9999,
      light: _variant(seed, Brightness.light, base.light),
      dark: _variant(seed, Brightness.dark, base.dark),
    );
  }

  static SchemeColors _variant(
    Color seed,
    Brightness brightness,
    SchemeColors base,
  ) {
    final neutral = NeutralTokens.of(brightness);
    var start = seed.withValues(alpha: 1);
    if (brightness == Brightness.dark) {
      // Dark mode wants a lighter, slightly desaturated tone of the same hue.
      final hsl = Hsl.fromColor(start);
      start = hsl
          .withLightness((hsl.lightness + 0.12).clamp(0.0, 0.85))
          .withSaturation((hsl.saturation * 0.95).clamp(0.0, 1.0))
          .toColor();
    }
    final accent = _accentFor(start, brightness, neutral);
    final ring = ColorUtils.ensureContrast(
      start,
      _worstSurface(brightness, neutral),
      minRatio: 3.2,
    );
    return SchemeColors(
      accent: accent,
      ring: ring,
      success: base.success,
      tasks: base.tasks,
    );
  }

  /// The surface with the least contrast against light/dark foregrounds.
  static Color _worstSurface(Brightness b, NeutralTokens n) =>
      b == Brightness.dark ? n.cardElevated : n.background;

  static Color _accentFor(Color start, Brightness b, NeutralTokens n) {
    var candidate = start;
    final tint = DesignTokens.tintOpacity(b);
    for (var i = 0; i < 100; i++) {
      final ok = [n.card, n.cardElevated, n.background].every(
        (surface) =>
            ColorUtils.contrastRatio(candidate, surface) >= 4.6 &&
            ColorUtils.contrastRatio(
                  candidate,
                  ColorUtils.blend(candidate, surface, tint),
                ) >=
                4.6,
      );
      if (ok) return candidate;
      final hsl = Hsl.fromColor(candidate);
      final next = b == Brightness.dark
          ? (hsl.lightness + 0.01).clamp(0.0, 1.0)
          : (hsl.lightness - 0.01).clamp(0.0, 1.0);
      candidate = hsl.withLightness(next).toColor();
    }
    return candidate;
  }
}
