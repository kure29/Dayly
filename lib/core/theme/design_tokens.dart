import 'dart:ui';

/// Neutral, scheme-independent color tokens (iOS system grays).
class NeutralTokens {
  const NeutralTokens({
    required this.background,
    required this.card,
    required this.cardElevated,
    required this.label,
    required this.secondaryLabel,
    required this.separator,
    required this.fill,
  });

  /// Grouped background.
  final Color background;
  final Color card;

  /// Sheets, popovers and other raised surfaces.
  final Color cardElevated;
  final Color label;
  final Color secondaryLabel;

  /// Hairline separators (drawn at 0.5 logical px).
  final Color separator;

  /// Track color of progress bars and rings.
  final Color fill;

  static const light = NeutralTokens(
    background: Color(0xFFF2F2F7),
    card: Color(0xFFFFFFFF),
    cardElevated: Color(0xFFFFFFFF),
    label: Color(0xFF1C1C1E),
    secondaryLabel: Color(0xFF6E6E73),
    separator: Color(0xFFE5E5EA),
    fill: Color(0xFFE5E5EA),
  );

  static const dark = NeutralTokens(
    background: Color(0xFF000000),
    card: Color(0xFF1C1C1E),
    cardElevated: Color(0xFF2C2C2E),
    label: Color(0xFFFFFFFF),
    secondaryLabel: Color(0xFF98989D),
    separator: Color(0xFF38383A),
    fill: Color(0xFF3A3A3C),
  );

  static NeutralTokens of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

/// Spacing, radii and type scale.
abstract final class DesignTokens {
  static const double groupRadius = 14;
  static const double iconRadius = 8;
  static const double iconSize = 30;
  static const double separatorWidth = 0.5;
  static const double gutter = 16;
  static const double rowMinHeight = 52;

  /// Opacity of the accent tint behind tinted capsule buttons.
  static const double tintOpacityLight = 0.12;
  static const double tintOpacityDark = 0.18;

  static double tintOpacity(Brightness b) =>
      b == Brightness.dark ? tintOpacityDark : tintOpacityLight;

  // Type scale (system font).
  static const double largeTitleSize = 34;
  static const double titleSize = 20;
  static const double bodySize = 17;
  static const double subheadSize = 15;
  static const double footnoteSize = 13;
}
