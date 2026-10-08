import 'dart:math' as math;
import 'dart:ui';

/// Color helpers shared by the theme system, the scheme generator and tests.
abstract final class ColorUtils {
  /// Parses `#RRGGBB` or `#AARRGGBB` into a [Color].
  static Color parseHex(String hex) {
    var value = hex.trim().replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) {
      throw FormatException('Invalid color "$hex"');
    }
    return Color(int.parse(value, radix: 16));
  }

  /// Formats [color] as `#RRGGBB` (alpha dropped).
  static String toHex(Color color) {
    final rgb = color.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// WCAG 2.x relative luminance.
  static double relativeLuminance(Color color) {
    double channel(double c) => c <= 0.04045
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(color.r) +
        0.7152 * channel(color.g) +
        0.0722 * channel(color.b);
  }

  /// WCAG 2.x contrast ratio between two opaque colors (1–21).
  static double contrastRatio(Color a, Color b) {
    final la = relativeLuminance(a);
    final lb = relativeLuminance(b);
    final hi = math.max(la, lb);
    final lo = math.min(la, lb);
    return (hi + 0.05) / (lo + 0.05);
  }

  /// Composites [foreground] with [opacity] over an opaque [background].
  static Color blend(Color foreground, Color background, double opacity) {
    return Color.lerp(background, foreground.withValues(alpha: 1), opacity)!;
  }

  /// White or black, whichever reads better on [background].
  static Color bestOn(Color background) {
    const white = Color(0xFFFFFFFF);
    const black = Color(0xFF000000);
    return contrastRatio(white, background) >= contrastRatio(black, background)
        ? white
        : black;
  }

  /// Darkens (towards black) or lightens (towards white) [color] in HSL space
  /// until it reaches [minRatio] against [background]. Returns the first color
  /// that satisfies the ratio, or the extreme if none does.
  static Color ensureContrast(
    Color color,
    Color background, {
    required double minRatio,
  }) {
    if (contrastRatio(color, background) >= minRatio) return color;
    final darken =
        relativeLuminance(background) > 0.5; // light background → darken
    var hsl = Hsl.fromColor(color.withValues(alpha: 1));
    for (var i = 0; i < 100; i++) {
      final l = (hsl.lightness + (darken ? -0.01 : 0.01)).clamp(0.0, 1.0);
      hsl = hsl.withLightness(l);
      final candidate = hsl.toColor();
      if (contrastRatio(candidate, background) >= minRatio) return candidate;
      if (l == 0 || l == 1) break;
    }
    return hsl.toColor();
  }
}

/// Minimal HSL representation (kept local so this file only needs dart:ui).
class Hsl {
  const Hsl(this.hue, this.saturation, this.lightness);

  final double hue;
  final double saturation;
  final double lightness;

  factory Hsl.fromColor(Color color) {
    final r = color.r, g = color.g, b = color.b;
    final maxC = math.max(r, math.max(g, b));
    final minC = math.min(r, math.min(g, b));
    final delta = maxC - minC;
    final l = (maxC + minC) / 2;
    var h = 0.0;
    if (delta != 0) {
      if (maxC == r) {
        h = 60 * (((g - b) / delta) % 6);
      } else if (maxC == g) {
        h = 60 * (((b - r) / delta) + 2);
      } else {
        h = 60 * (((r - g) / delta) + 4);
      }
    }
    if (h < 0) h += 360;
    final s = delta == 0 ? 0.0 : delta / (1 - (2 * l - 1).abs());
    return Hsl(h, s.clamp(0.0, 1.0), l);
  }

  Hsl withLightness(double l) => Hsl(hue, saturation, l);

  Hsl withSaturation(double s) => Hsl(hue, s, lightness);

  Color toColor() {
    final c = (1 - (2 * lightness - 1).abs()) * saturation;
    final hp = hue / 60;
    final x = c * (1 - (hp % 2 - 1).abs());
    double r = 0, g = 0, b = 0;
    if (hp < 1) {
      r = c;
      g = x;
    } else if (hp < 2) {
      r = x;
      g = c;
    } else if (hp < 3) {
      g = c;
      b = x;
    } else if (hp < 4) {
      g = x;
      b = c;
    } else if (hp < 5) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }
    final m = lightness - c / 2;
    return Color.from(
      alpha: 1,
      red: (r + m).clamp(0.0, 1.0),
      green: (g + m).clamp(0.0, 1.0),
      blue: (b + m).clamp(0.0, 1.0),
    );
  }
}
