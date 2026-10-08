import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../domain/models.dart';
import '../../domain/stats.dart';
import 'progress_card.dart';
import 'progress_input_sheet.dart';
import 'task_row.dart';
import 'today_actions.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final date = ref.watch(todayDateProvider).value;
    final tasks = ref.watch(todayTasksProvider);
    final streak = ref.watch(streakProvider).value?.current ?? 0;
    final profile = ref.watch(profileProvider).value;
    final clock = ref.watch(clockProvider);

    return LargeTitlePage(
      eyebrow: date == null ? null : context.longDate(date.toDateTime()),
      title: l10n.tabToday,
      subtitle: profile == null
          ? null
          : _greeting(l10n, clock().hour, profile.nickname),
      trailing: profile == null ? null : _Avatar(char: profile.avatarChar),
      slivers: [
        ...switch (tasks) {
          AsyncData(:final value) => _content(
            context,
            ref,
            value,
            date,
            streak,
          ),
          AsyncError(:final error) => [
            SliverToBoxAdapter(child: Center(child: Text('$error'))),
          ],
          _ => [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ),
          ],
        },
      ],
    );
  }

  List<Widget> _content(
    BuildContext context,
    WidgetRef ref,
    List<TodayTask> items,
    LocalDate? date,
    int streak,
  ) {
    final summary = DaySummary.of(
      date ?? LocalDate.fromDateTime(DateTime.now()),
      items.map((i) => i.task),
    );
    return [
      SliverToBoxAdapter(
        child: ProgressCard(summary: summary, streak: streak),
      ),
      if (items.isEmpty) const SliverToBoxAdapter(child: _EmptyState()),
      SliverToBoxAdapter(
        child: GroupedSection(
          children: [
            for (final item in items)
              TaskRow(
                key: ValueKey('task-${item.task.id}'),
                item: item,
                onCheckIn: () =>
                    TodayActions.checkIn(context, ref, item.task.id),
                onUndo: () => TodayActions.undo(ref, item.task.id),
                onEdit: () => context.push(Routes.editTask(item.template.id)),
                onLongPress: () async {
                  final value = await showProgressInputSheet(
                    context,
                    item.task,
                  );
                  if (value != null && context.mounted) {
                    await TodayActions.setProgress(
                      context,
                      ref,
                      item.task.id,
                      value,
                    );
                  }
                },
              ),
            AddTaskRow(onTap: () => context.push(Routes.newTask)),
          ],
        ),
      ),
    ];
  }

  static String _greeting(AppLocalizations l10n, int hour, String name) =>
      switch (hour) {
        >= 5 && < 12 => l10n.greetingMorning(name),
        >= 12 && < 18 => l10n.greetingAfternoon(name),
        >= 18 && < 23 => l10n.greetingEvening(name),
        _ => l10n.greetingNight(name),
      };
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.char});

  final String char;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: p.accentTint, shape: BoxShape.circle),
      child: Text(
        char,
        style: AppTextStyles.headline.copyWith(color: p.accent),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
      child: Column(
        children: [
          Icon(CupertinoIcons.sun_max, size: 40, color: p.secondaryLabel),
          const SizedBox(height: 8),
          Text(
            l10n.noTasksToday,
            style: AppTextStyles.headline.copyWith(color: p.label),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.noTasksHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
          ),
          const SizedBox(height: DesignTokens.gutter),
        ],
      ),
    );
  }
}
