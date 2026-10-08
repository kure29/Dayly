import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'design_tokens.dart';
import 'scheme_definition.dart';

/// Every color a widget may use. Read it with `context.palette`; never
/// hard-code colors in feature code.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brightness,
    required this.background,
    required this.card,
    required this.cardElevated,
    required this.label,
    required this.secondaryLabel,
    required this.separator,
    required this.fill,
    required this.accent,
    required this.onAccent,
    required this.accentTint,
    required this.ring,
    required this.success,
    required this.taskColors,
    required this.onTaskColors,
    required this.destructive,
    required this.barBackground,
    required this.scrim,
  });

  factory AppPalette.from(SchemeDefinition scheme, Brightness brightness) {
    final n = NeutralTokens.of(brightness);
    final c = scheme.colorsFor(brightness);
    return AppPalette(
      brightness: brightness,
      background: n.background,
      card: n.card,
      cardElevated: n.cardElevated,
      label: n.label,
      secondaryLabel: n.secondaryLabel,
      separator: n.separator,
      fill: n.fill,
      accent: c.accent,
      onAccent: ColorUtils.bestOn(c.accent),
      accentTint: ColorUtils.blend(
        c.accent,
        n.card,
        DesignTokens.tintOpacity(brightness),
      ),
      ring: c.ring,
      success: c.success,
      taskColors: c.tasks,
      onTaskColors: c.tasks.map(ColorUtils.bestOn).toList(growable: false),
      destructive: brightness == Brightness.dark
          ? const Color(0xFFFF6961)
          : const Color(0xFFD70015),
      barBackground: (brightness == Brightness.dark
          ? const Color(0xFF161618)
          : const Color(0xFFF9F9F9)),
      scrim: const Color(0x66000000),
    );
  }

  final Brightness brightness;
  final Color background;
  final Color card;
  final Color cardElevated;
  final Color label;
  final Color secondaryLabel;
  final Color separator;
  final Color fill;
  final Color accent;

  /// Text/icon color on a solid [accent] fill.
  final Color onAccent;

  /// Opaque accent tint used behind tinted capsule buttons.
  final Color accentTint;
  final Color ring;
  final Color success;
  final List<Color> taskColors;
  final List<Color> onTaskColors;
  final Color destructive;

  /// Base color of translucent bars (painted with opacity over a blur).
  final Color barBackground;
  final Color scrim;

  Color taskColor(int index) => taskColors[index % taskColors.length];

  Color onTaskColor(int index) => onTaskColors[index % onTaskColors.length];

  bool get isDark => brightness == Brightness.dark;

  @override
  AppPalette copyWith({Color? accent}) => accent == null
      ? this
      : AppPalette(
          brightness: brightness,
          background: background,
          card: card,
          cardElevated: cardElevated,
          label: label,
          secondaryLabel: secondaryLabel,
          separator: separator,
          fill: fill,
          accent: accent,
          onAccent: ColorUtils.bestOn(accent),
          accentTint: ColorUtils.blend(
            accent,
            card,
            DesignTokens.tintOpacity(brightness),
          ),
          ring: ring,
          success: success,
          taskColors: taskColors,
          onTaskColors: onTaskColors,
          destructive: destructive,
          barBackground: barBackground,
          scrim: scrim,
        );

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: l(background, other.background),
      card: l(card, other.card),
      cardElevated: l(cardElevated, other.cardElevated),
      label: l(label, other.label),
      secondaryLabel: l(secondaryLabel, other.secondaryLabel),
      separator: l(separator, other.separator),
      fill: l(fill, other.fill),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentTint: l(accentTint, other.accentTint),
      ring: l(ring, other.ring),
      success: l(success, other.success),
      taskColors: [
        for (var i = 0; i < taskColors.length; i++)
          l(taskColors[i], other.taskColor(i)),
      ],
      onTaskColors: [
        for (var i = 0; i < onTaskColors.length; i++)
          l(onTaskColors[i], other.onTaskColor(i)),
      ],
      destructive: l(destructive, other.destructive),
      barBackground: l(barBackground, other.barBackground),
      scrim: l(scrim, other.scrim),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
