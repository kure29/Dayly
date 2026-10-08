import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n.dart';
import '../core/ui/blur_tab_bar.dart';

/// Root scaffold with the frosted bottom tab bar (今日 / 统计 / 我的).
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: BlurTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: [
          BlurTabItem(
            icon: CupertinoIcons.checkmark_circle,
            activeIcon: CupertinoIcons.checkmark_circle_fill,
            label: l10n.tabToday,
          ),
          BlurTabItem(
            icon: CupertinoIcons.chart_bar,
            activeIcon: CupertinoIcons.chart_bar_fill,
            label: l10n.tabStats,
          ),
          BlurTabItem(
            icon: CupertinoIcons.person_crop_circle,
            activeIcon: CupertinoIcons.person_crop_circle_fill,
            label: l10n.tabMe,
          ),
        ],
      ),
    );
  }
}
