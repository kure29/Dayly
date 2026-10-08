import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

enum CapsuleStyle {
  /// Solid accent background, [AppPalette.onAccent] text.
  filled,

  /// Accent tint background, accent text (iOS "tinted" button).
  tinted,

  /// Neutral fill background, label text.
  gray,
}

/// A pill-shaped button with a subtle press-scale animation.
class CapsuleButton extends StatefulWidget {
  const CapsuleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = CapsuleStyle.tinted,
    this.icon,
    this.dense = false,
    this.expand = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final CapsuleStyle style;
  final IconData? icon;
  final bool dense;
  final bool expand;
  final String? semanticLabel;

  @override
  State<CapsuleButton> createState() => _CapsuleButtonState();
}

class _CapsuleButtonState extends State<CapsuleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = widget.onPressed != null;
    final (bg, fg) = switch (widget.style) {
      CapsuleStyle.filled => (p.accent, p.onAccent),
      CapsuleStyle.tinted => (p.accentTint, p.accent),
      CapsuleStyle.gray => (p.fill, p.label),
    };
    final textStyle =
        (widget.dense ? AppTextStyles.subhead : AppTextStyles.headline)
            .copyWith(color: fg, fontWeight: FontWeight.w600);
    final child = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: widget.dense ? 15 : 18, color: fg),
          const SizedBox(width: 4),
        ],
        Text(widget.label, style: textStyle, maxLines: 1),
      ],
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration: const Duration(milliseconds: 110),
          child: AnimatedOpacity(
            opacity: enabled ? (_pressed ? 0.75 : 1) : 0.4,
            duration: const Duration(milliseconds: 110),
            child: Container(
              constraints: BoxConstraints(
                minHeight: widget.dense ? 30 : 50,
                minWidth: widget.dense ? 56 : 0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.dense ? 14 : 22,
                vertical: widget.dense ? 5 : 12,
              ),
              alignment: widget.expand ? Alignment.center : null,
              decoration: ShapeDecoration(
                color: bg,
                shape: const StadiumBorder(),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
