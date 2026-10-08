import 'package:flutter/cupertino.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';

/// An inset grouped section (iOS "insetGrouped" table style): optional header,
/// a rounded card holding [children] separated by hairlines, optional footer.
class GroupedSection extends StatelessWidget {
  const GroupedSection({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.separatorIndent,
    this.margin = const EdgeInsets.fromLTRB(
      DesignTokens.gutter,
      0,
      DesignTokens.gutter,
      24,
    ),
  });

  final List<Widget> children;
  final String? header;
  final String? footer;

  /// Leading indent of separators. Defaults to aligning with the text of
  /// [GroupedRow]s that have a leading icon.
  final double? separatorIndent;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final indent =
        separatorIndent ??
        DesignTokens.gutter + DesignTokens.iconSize + 12; // icon + gap
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(HairlineSeparator(indent: indent));
      }
    }
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.gutter,
                0,
                DesignTokens.gutter,
                6,
              ),
              child: Text(
                header!,
                style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.groupRadius),
            child: ColoredBox(
              color: p.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rows,
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.gutter,
                6,
                DesignTokens.gutter,
                0,
              ),
              child: Text(
                footer!,
                style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
              ),
            ),
        ],
      ),
    );
  }
}

/// A 0.5px separator line with a leading [indent].
class HairlineSeparator extends StatelessWidget {
  const HairlineSeparator({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: indent),
      child: Container(
        height: DesignTokens.separatorWidth,
        color: context.palette.separator,
      ),
    );
  }
}

/// A standard row inside a [GroupedSection].
class GroupedRow extends StatelessWidget {
  const GroupedRow({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.destructive = false,
    this.titleColor,
  });

  final String title;
  final Widget? leading;
  final String? subtitle;

  /// Secondary text shown on the trailing side.
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final content = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: DesignTokens.rowMinHeight - 8,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.gutter,
          vertical: 10,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      color:
                          titleColor ?? (destructive ? p.destructive : p.label),
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: AppTextStyles.footnote.copyWith(
                          color: p.secondaryLabel,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  value!,
                  style: AppTextStyles.body.copyWith(color: p.secondaryLabel),
                ),
              ),
            ?trailing,
            if (showChevron)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 16,
                  color: p.secondaryLabel,
                ),
              ),
          ],
        ),
      ),
    );
    if (onTap == null) return content;
    return PressableHighlight(onTap: onTap!, child: content);
  }
}

/// iOS-like press feedback: the row darkens slightly while pressed.
class PressableHighlight extends StatefulWidget {
  const PressableHighlight({
    super.key,
    required this.onTap,
    required this.child,
    this.onLongPress,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  @override
  State<PressableHighlight> createState() => _PressableHighlightState();
}

class _PressableHighlightState extends State<PressableHighlight> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _pressed
            ? p.fill.withValues(alpha: 0.6)
            : p.card.withValues(alpha: 0),
        child: widget.child,
      ),
    );
  }
}
