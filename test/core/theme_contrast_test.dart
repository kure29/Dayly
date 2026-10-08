import 'dart:ui';

import 'package:dailyquest/core/theme/app_palette.dart';
import 'package:dailyquest/core/theme/color_utils.dart';
import 'package:dailyquest/core/theme/custom_scheme.dart';
import 'package:dailyquest/core/theme/scheme_definition.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/schemes.dart';

const _text = 4.5;
const _graphic = 3.0;

/// Asserts every contrast rule of the design system for [scheme].
void expectAccessible(SchemeDefinition scheme) {
  for (final b in Brightness.values) {
    final p = AppPalette.from(scheme, b);
    final where = '${scheme.id}/${b.name}';
    final surfaces = {
      'background': p.background,
      'card': p.card,
      'cardElevated': p.cardElevated,
    };
    void check(String what, Color fg, Color bg, double min) {
      final ratio = ColorUtils.contrastRatio(fg, bg);
      expect(
        ratio,
        greaterThanOrEqualTo(min),
        reason: '$where: $what is ${ratio.toStringAsFixed(2)}:1, needs $min',
      );
    }

    for (final s in surfaces.entries) {
      check('label on ${s.key}', p.label, s.value, _text);
      check('secondaryLabel on ${s.key}', p.secondaryLabel, s.value, _text);
      check('accent text on ${s.key}', p.accent, s.value, _text);
      check('destructive on ${s.key}', p.destructive, s.value, _text);
      check('ring on ${s.key}', p.ring, s.value, _graphic);
      check('success on ${s.key}', p.success, s.value, _graphic);
    }
    check('accent text on tinted capsule', p.accent, p.accentTint, _text);
    check('onAccent on accent', p.onAccent, p.accent, _text);
    for (var i = 0; i < p.taskColors.length; i++) {
      check('glyph on task color $i', p.onTaskColor(i), p.taskColor(i), _text);
    }
  }
}

void main() {
  final registry = loadRegistryFromDisk();

  test('ships the five built-in schemes', () {
    expect(registry.schemes.map((s) => s.id), [
      'classic_blue',
      'indigo',
      'rose',
      'forest',
      'warm_orange',
    ]);
  });

  for (final scheme in registry.schemes) {
    test('scheme ${scheme.id} meets contrast requirements', () {
      expectAccessible(scheme);
    });
  }

  test('custom accents are adjusted to meet contrast for any hue', () {
    for (var hue = 0; hue < 360; hue += 15) {
      for (final lightness in [0.2, 0.45, 0.6, 0.8]) {
        for (final saturation in [0.3, 0.9]) {
          final seed = Hsl(hue.toDouble(), saturation, lightness).toColor();
          final scheme = CustomSchemeGenerator.generate(
            seed,
            base: registry.fallback,
          );
          expectAccessible(scheme);
        }
      }
    }
  });

  test('custom dark variant is lighter than the light variant', () {
    final scheme = CustomSchemeGenerator.generate(
      const Color(0xFF8E44AD),
      base: registry.fallback,
    );
    expect(
      ColorUtils.relativeLuminance(scheme.dark.accent),
      greaterThan(ColorUtils.relativeLuminance(scheme.light.accent)),
    );
  });

  test('contrast ratio matches WCAG reference values', () {
    expect(
      ColorUtils.contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.001),
    );
    expect(
      ColorUtils.contrastRatio(const Color(0xFF777777), const Color(0xFFFFFFFF)),
      closeTo(4.48, 0.01),
    );
  });
}
