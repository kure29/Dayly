import 'package:flutter/cupertino.dart';

import '../../core/format.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/capsule_button.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/progress_indicators.dart';
import '../../core/ui/swipe_actions.dart';
import '../../core/ui/task_icon.dart';
import '../../domain/models.dart';

/// Label of the check-in button: "完成" for single-step tasks, else "+step".
String checkInLabel(AppLocalizations l10n, DailyTask t) =>
    t.type == TaskType.once || t.step >= t.target ? l10n.done : '+${t.step}';

/// One task in today's list.
class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.item,
    required this.onCheckIn,
    required this.onUndo,
    required this.onEdit,
    required this.onLongPress,
  });

  final TodayTask item;
  final VoidCallback onCheckIn;
  final VoidCallback onUndo;
  final VoidCallback onEdit;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final t = item.task;
    final done = t.isCompleted;
    final progressText = l10n.progressOf(
      context.amount(t.progress),
      context.amount(t.target),
      t.unit,
    );
    return SwipeActions(
      actions: [
        SwipeAction(
          label: l10n.undo,
          icon: CupertinoIcons.arrow_uturn_left,
          color: p.secondaryLabel,
          onTap: onUndo,
        ),
        SwipeAction(
          label: l10n.edit,
          icon: CupertinoIcons.pencil,
          color: p.accent,
          onTap: onEdit,
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: onLongPress,
        child: Semantics(
          label: '${t.name}, $progressText',
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.gutter,
              vertical: 12,
            ),
            child: Row(
              children: [
                TaskIcon(icon: item.icon, colorIndex: item.colorIndex),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: done ? p.secondaryLabel : p.label,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: p.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ThinProgressBar(
                        value: t.fraction,
                        color: done ? p.success : p.taskColor(item.colorIndex),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        progressText,
                        style: AppTextStyles.footnote.copyWith(
                          color: p.secondaryLabel,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (done)
                  Semantics(
                    label: l10n.done,
                    child: Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: p.success,
                      size: 30,
                    ),
                  )
                else
                  CapsuleButton(
                    key: ValueKey('checkin-${t.id}'),
                    label: checkInLabel(l10n, t),
                    dense: true,
                    onPressed: onCheckIn,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "添加任务" row at the end of the list.
class AddTaskRow extends StatelessWidget {
  const AddTaskRow({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GroupedRow(
      key: const ValueKey('add-task'),
      title: context.l10n.addTask,
      titleColor: p.accent,
      leading: SizedBox(
        width: DesignTokens.iconSize,
        child: Icon(
          CupertinoIcons.add_circled_solid,
          color: p.accent,
          size: 26,
        ),
      ),
      onTap: onTap,
    );
  }
}
