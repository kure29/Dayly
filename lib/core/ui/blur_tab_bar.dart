import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/design_tokens.dart';

class BlurTabItem {
  const BlurTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Bottom tab bar with a frosted-glass background and a hairline on top.
/// Use with `Scaffold(extendBody: true)` so content scrolls underneath.
class BlurTabBar extends StatelessWidget {
  const BlurTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BlurTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double barHeight = 50;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: p.barBackground.withValues(alpha: 0.82),
            border: Border(
              top: BorderSide(
                color: p.separator,
                width: DesignTokens.separatorWidth,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: SizedBox(
              height: barHeight,
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == currentIndex,
                        button: true,
                        label: items[i].label,
                        excludeSemantics: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(i),
                          child: _TabItem(
                            item: items[i],
                            active: i == currentIndex,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.item, required this.active});

  final BlurTabItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = active ? p.accent : p.secondaryLabel;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(active ? item.activeIcon : item.icon, size: 25, color: color),
        const SizedBox(height: 2),
        Text(
          item.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
