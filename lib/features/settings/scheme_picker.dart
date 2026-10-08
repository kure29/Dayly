import 'package:flutter/cupertino.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/color_utils.dart';
import '../../core/theme/custom_scheme.dart';
import '../../core/theme/scheme_definition.dart';

/// A tappable preview card of one scheme: accent/ring/success dots and the
/// first task colors, for the current brightness.
class SchemePreviewTile extends StatelessWidget {
  const SchemePreviewTile({
    super.key,
    required this.scheme,
    required this.selected,
    required this.onTap,
    this.label,
  });

  final SchemeDefinition scheme;
  final bool selected;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final colors = scheme.colorsFor(p.brightness);
    final name =
        label ??
        scheme.displayName(Localizations.localeOf(context).languageCode);
    return Semantics(
      button: true,
      selected: selected,
      label: name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 104,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? colors.accent : p.separator,
              width: selected ? 2 : 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Dot(color: colors.accent, size: 22),
                  const SizedBox(width: 4),
                  _Dot(color: colors.ring, size: 14),
                  const SizedBox(width: 3),
                  _Dot(color: colors.success, size: 14),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 3,
                runSpacing: 3,
                children: [
                  for (final c in colors.tasks) _Dot(color: c, size: 9),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.footnote.copyWith(
                        color: p.label,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(
                      CupertinoIcons.checkmark_alt,
                      size: 14,
                      color: colors.accent,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// Horizontal list of all schemes plus the custom-accent tile.
class SchemeStrip extends StatelessWidget {
  const SchemeStrip({
    super.key,
    required this.schemes,
    required this.selectedId,
    required this.onSelect,
    required this.customScheme,
    required this.onCustomTap,
  });

  final List<SchemeDefinition> schemes;
  final String selectedId;
  final ValueChanged<String> onSelect;

  /// Generated custom scheme, or `null` if the user never picked one.
  final SchemeDefinition? customScheme;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: schemes.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          if (i < schemes.length) {
            final s = schemes[i];
            return SchemePreviewTile(
              scheme: s,
              selected: s.id == selectedId,
              onTap: () => onSelect(s.id),
            );
          }
          if (customScheme != null) {
            return SchemePreviewTile(
              scheme: customScheme!,
              selected: selectedId == CustomSchemeGenerator.id,
              label: context.l10n.customAccent,
              onTap: onCustomTap,
            );
          }
          return GestureDetector(
            onTap: onCustomTap,
            child: Container(
              width: 104,
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.separator, width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.eyedropper, color: p.accent),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.customAccent,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(color: p.label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Hue + lightness picker for the custom accent. Returns the chosen ARGB.
class AccentColorPicker extends StatefulWidget {
  const AccentColorPicker({
    super.key,
    required this.initial,
    required this.onDone,
  });

  final Color initial;
  final ValueChanged<Color> onDone;

  @override
  State<AccentColorPicker> createState() => _AccentColorPickerState();
}

class _AccentColorPickerState extends State<AccentColorPicker> {
  late double _hue;
  late double _lightness;
  late double _saturation;

  @override
  void initState() {
    super.initState();
    final hsl = Hsl.fromColor(widget.initial);
    _hue = hsl.hue;
    _saturation = hsl.saturation < 0.35 ? 0.8 : hsl.saturation;
    _lightness = hsl.lightness.clamp(0.25, 0.65);
  }

  Color get _color => Hsl(_hue, _saturation, _lightness).toColor();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final generated = CustomSchemeGenerator.generate(
      _color,
      base: SchemeDefinition(
        id: 'tmp',
        names: const {},
        light: SchemeColors(
          accent: _color,
          ring: _color,
          success: p.success,
          tasks: p.taskColors,
        ),
        dark: SchemeColors(
          accent: _color,
          ring: _color,
          success: p.success,
          tasks: p.taskColors,
        ),
      ),
    );
    final hues = [
      for (var h = 0; h <= 360; h += 30) Hsl(h % 360, 0.85, 0.5).toColor(),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Swatch(color: generated.light.accent, label: '☀︎'),
              const SizedBox(width: 16),
              _Swatch(color: generated.dark.accent, label: '☾'),
            ],
          ),
          const SizedBox(height: 16),
          _GradientSlider(
            colors: hues,
            value: _hue / 360,
            onChanged: (v) => setState(() => _hue = v * 360),
          ),
          const SizedBox(height: 14),
          _GradientSlider(
            colors: [
              Hsl(_hue, _saturation, 0.25).toColor(),
              Hsl(_hue, _saturation, 0.45).toColor(),
              Hsl(_hue, _saturation, 0.65).toColor(),
            ],
            value: (_lightness - 0.25) / 0.4,
            onChanged: (v) => setState(() => _lightness = 0.25 + v * 0.4),
          ),
          const SizedBox(height: 20),
          FilledButtonLike(
            label: context.l10n.confirm,
            color: generated.colorsFor(p.brightness).accent,
            onPressed: () => widget.onDone(_color),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        label,
        style: TextStyle(color: ColorUtils.bestOn(color), fontSize: 20),
      ),
    );
  }
}

/// Full-width filled pill with an explicit color (used for previews where the
/// palette's accent isn't the color being shown yet).
class FilledButtonLike extends StatelessWidget {
  const FilledButtonLike({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
        child: Text(
          label,
          style: AppTextStyles.headline.copyWith(
            color: ColorUtils.bestOn(color),
          ),
        ),
      ),
    );
  }
}

class _GradientSlider extends StatelessWidget {
  const _GradientSlider({
    required this.colors,
    required this.value,
    required this.onChanged,
  });

  final List<Color> colors;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        void update(Offset local) =>
            onChanged((local.dx / width).clamp(0.0, 1.0));
        return GestureDetector(
          onHorizontalDragUpdate: (d) => update(d.localPosition),
          onTapDown: (d) => update(d.localPosition),
          child: SizedBox(
            height: 32,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(colors: colors),
                  ),
                ),
                Positioned(
                  left: (value.clamp(0.0, 1.0) * (width - 28)),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.card,
                      border: Border.all(color: p.separator, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: p.scrim,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
