import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/color_utils.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/progress_indicators.dart';
import '../../core/ui/task_icon.dart';
import '../../domain/models.dart';
import '../../domain/stats.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final days = ref.watch(daySummariesProvider).value;
    final today = ref.watch(todayDateProvider).value;
    final tasks = ref.watch(allDailyTasksProvider).value;
    final templates = ref.watch(allTemplatesProvider).value;
    if (days == null || today == null || tasks == null || templates == null) {
      return LargeTitlePage(
        title: l10n.statsTitle,
        slivers: const [
          SliverToBoxAdapter(
            child: Center(child: CupertinoActivityIndicator()),
          ),
        ],
      );
    }
    final streak = Stats.streak(days, today);
    final perTask = Stats.perTemplate(
      templates,
      tasks,
    ).where((s) => s.scheduledDays > 0 || !s.template.isArchived).toList();
    return LargeTitlePage(
      title: l10n.statsTitle,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Card(
                title: l10n.thisWeek,
                child: _WeekRings(
                  values: Stats.week(days, today),
                  today: today,
                ),
              ),
              _Card(
                title: l10n.last12Weeks,
                child: _Heatmap(grid: Stats.heatmap(days, today)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _StreakTile(
                        label: l10n.currentStreak,
                        value: streak.current,
                        icon: CupertinoIcons.flame_fill,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StreakTile(
                        label: l10n.longestStreak,
                        value: streak.longest,
                        icon: CupertinoIcons.rosette,
                      ),
                    ),
                  ],
                ),
              ),
              if (perTask.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.noStatsYet,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.palette.secondaryLabel,
                    ),
                  ),
                )
              else
                GroupedSection(
                  header: l10n.perTask,
                  children: [for (final s in perTask) _TaskStatRow(stats: s)],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(DesignTokens.groupRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.title.copyWith(color: p.label)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _WeekRings extends StatelessWidget {
  const _WeekRings({required this.values, required this.today});

  final List<double?> values;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final monday = today.startOfWeek;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 7; i++)
          Builder(
            builder: (context) {
              final date = monday.addDays(i);
              final isToday = date == today;
              final v = values[i];
              return Semantics(
                label:
                    '${context.shortWeekday(date.toDateTime())} '
                    '${v == null ? '-' : '${(v * 100).round()}%'}',
                excludeSemantics: true,
                child: Column(
                  children: [
                    ProgressRing(
                      value: v ?? 0,
                      size: 36,
                      strokeWidth: 5,
                      color: v == 1 ? p.success : p.ring,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.shortWeekday(date.toDateTime()),
                      style: AppTextStyles.footnote.copyWith(
                        color: isToday ? p.accent : p.secondaryLabel,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.grid});

  /// weeks × 7.
  final List<List<double?>> grid;

  static Color colorFor(AppPalette p, double? v) {
    if (v == null) return p.fill.withValues(alpha: 0.5);
    if (v <= 0) return p.fill;
    final level = v >= 1 ? 1.0 : (v >= 0.5 ? 0.65 : 0.35);
    return ColorUtils.blend(p.ring, p.card, level);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 4.0;
        final cell =
            ((constraints.maxWidth - gap * (grid.length - 1)) / grid.length)
                .clamp(8.0, 22.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final week in grid)
                  Column(
                    children: [
                      for (final v in week)
                        Container(
                          width: cell,
                          height: cell,
                          margin: const EdgeInsets.only(bottom: gap),
                          decoration: BoxDecoration(
                            color: colorFor(p, v),
                            borderRadius: BorderRadius.circular(cell / 4),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.heatLess,
                  style: AppTextStyles.footnote.copyWith(
                    color: p.secondaryLabel,
                  ),
                ),
                const SizedBox(width: 6),
                for (final v in [0.0, 0.3, 0.6, 1.0])
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      color: colorFor(p, v),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                const SizedBox(width: 3),
                Text(
                  l10n.heatMore,
                  style: AppTextStyles.footnote.copyWith(
                    color: p.secondaryLabel,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(DesignTokens.groupRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: p.accent),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.daysUnit(value),
            style: AppTextStyles.title.copyWith(color: p.label),
          ),
        ],
      ),
    );
  }
}

class _TaskStatRow extends StatelessWidget {
  const _TaskStatRow({required this.stats});

  final TemplateStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = stats.template;
    return GroupedRow(
      leading: TaskIcon(icon: t.icon, colorIndex: t.colorIndex),
      title: t.name,
      subtitle: l10n.taskTotal(context.amount(stats.totalAmount), t.unit),
      value: l10n.completionRate((stats.completionRate * 100).round()),
    );
  }
}
