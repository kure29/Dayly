import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import '../theme/color_utils.dart';

class SwipeAction {
  const SwipeAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

/// iOS-style trailing swipe actions: drag the row left to reveal [actions].
class SwipeActions extends StatefulWidget {
  const SwipeActions({super.key, required this.actions, required this.child});

  final List<SwipeAction> actions;
  final Widget child;

  @override
  State<SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<SwipeActions>
    with SingleTickerProviderStateMixin {
  static const double _actionWidth = 76;

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  double get _maxExtent => _actionWidth * widget.actions.length;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _c.value = (_c.value - d.primaryDelta! / _maxExtent).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails d) {
    final v = d.primaryVelocity ?? 0;
    if (v < -300 || (v.abs() <= 300 && _c.value > 0.4)) {
      _c.animateTo(1, curve: Curves.easeOutCubic);
    } else {
      _c.animateTo(0, curve: Curves.easeOutCubic);
    }
  }

  void close() => _c.animateTo(0, curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final offset = _c.value * _maxExtent;
          return Stack(
            children: [
              if (offset > 0)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (final a in widget.actions)
                        SizedBox(
                          width: offset / widget.actions.length,
                          child: Semantics(
                            button: true,
                            label: a.label,
                            child: GestureDetector(
                              onTap: () {
                                close();
                                a.onTap();
                              },
                              child: ColoredBox(
                                color: a.color,
                                child: ClipRect(
                                  child: OverflowBox(
                                    maxWidth: _actionWidth,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          a.icon,
                                          color: ColorUtils.bestOn(a.color),
                                          size: 20,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          a.label,
                                          maxLines: 1,
                                          style: AppTextStyles.footnote
                                              .copyWith(
                                                color: ColorUtils.bestOn(
                                                  a.color,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              Transform.translate(
                offset: Offset(-offset, 0),
                child: ColoredBox(color: p.card, child: child),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
