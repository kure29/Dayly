import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import 'blur_tab_bar.dart';

/// A tab root page with an iOS-style large title that scrolls with content.
class LargeTitlePage extends StatelessWidget {
  const LargeTitlePage({
    super.key,
    required this.title,
    required this.slivers,
    this.eyebrow,
    this.subtitle,
    this.trailing,
  });

  final String title;

  /// Small secondary text above the title (e.g. the date).
  final String? eyebrow;

  /// Text below the title (e.g. a greeting).
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: p.background,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 12, 20, 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eyebrow != null)
                          Text(
                            eyebrow!,
                            style: AppTextStyles.footnote.copyWith(
                              color: p.secondaryLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        Semantics(
                          header: true,
                          child: Text(
                            title,
                            style: AppTextStyles.largeTitle.copyWith(
                              color: p.label,
                            ),
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              style: AppTextStyles.subhead.copyWith(
                                color: p.secondaryLabel,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ),
          ...slivers,
          SliverToBoxAdapter(
            child: SizedBox(
              height: BlurTabBar.barHeight + media.padding.bottom + 24,
            ),
          ),
        ],
      ),
    );
  }
}

/// A pushed page with a compact centered navigation bar and back button.
class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: p.background,
        leading:
            leading ??
            (Navigator.of(context).canPop()
                ? CupertinoNavigationBarBackButton(
                    color: p.accent,
                    onPressed: () => Navigator.of(context).maybePop(),
                  )
                : null),
        actions: actions,
        shape: Border(bottom: BorderSide(color: p.separator, width: 0.5)),
      ),
      body: body,
    );
  }
}

/// A text button in the navigation bar (e.g. "取消" / "保存").
class NavTextButton extends StatelessWidget {
  const NavTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bold = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: onPressed == null ? p.secondaryLabel : p.accent,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
