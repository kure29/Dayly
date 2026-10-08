import 'package:flutter/cupertino.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/progress_indicators.dart';
import '../../domain/stats.dart';

/// Ring + "已完成 2/4" + streak.
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.summary, required this.streak});

  final DaySummary summary;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final percent = (summary.completionRatio * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.gutter,
        0,
        DesignTokens.gutter,
        24,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(DesignTokens.groupRadius),
        ),
        child: Row(
          children: [
            ProgressRing(
              value: summary.completionRatio,
              size: 92,
              strokeWidth: 11,
              color: summary.isComplete ? p.success : p.ring,
              child: Text(
                '$percent%',
                style: AppTextStyles.headline.copyWith(color: p.label),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todayCompleted(summary.completed, summary.total),
                    key: const ValueKey('today-completed'),
                    style: AppTextStyles.title.copyWith(color: p.label),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.flame_fill,
                        size: 16,
                        color: streak > 0 ? p.accent : p.secondaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.streakDays(streak),
                        style: AppTextStyles.subhead.copyWith(
                          color: p.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ThinProgressBar(value: summary.weightedRatio, height: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
