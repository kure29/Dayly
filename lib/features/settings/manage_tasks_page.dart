import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/dialogs.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/swipe_actions.dart';
import '../../core/ui/task_icon.dart';
import '../../domain/models.dart';

/// Reorder (drag), pause/resume, edit and delete (archive) templates.
class ManageTasksPage extends ConsumerStatefulWidget {
  const ManageTasksPage({super.key});

  @override
  ConsumerState<ManageTasksPage> createState() => _ManageTasksPageState();
}

class _ManageTasksPageState extends ConsumerState<ManageTasksPage> {
  /// Local order while a drag is being persisted, to avoid flicker.
  List<TaskTemplate>? _optimistic;

  Future<void> _reorder(List<TaskTemplate> items, int from, int to) async {
    final list = [...items];
    list.insert(to, list.removeAt(from));
    setState(() => _optimistic = list);
    await ref
        .read(taskServiceProvider)
        .reorderTemplates(list.map((t) => t.id).toList());
    if (mounted) setState(() => _optimistic = null);
  }

  Future<void> _archive(TaskTemplate t) async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l10n.archiveConfirmTitle(t.name),
      message: l10n.archiveConfirmMessage,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (ok) await ref.read(taskServiceProvider).archiveTemplate(t.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    final templates = _optimistic ?? ref.watch(templatesProvider).value ?? [];
    return DetailPage(
      title: l10n.manageTasks,
      actions: [
        IconButton(
          tooltip: l10n.newTask,
          icon: Icon(CupertinoIcons.add, color: p.accent),
          onPressed: () => context.push(Routes.newTask),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.gutter,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.groupRadius),
              child: ColoredBox(
                color: p.card,
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: templates.length,
                  onReorderItem: (from, to) => _reorder(templates, from, to),
                  proxyDecorator: (child, _, _) => Material(
                    color: p.cardElevated,
                    elevation: 6,
                    shadowColor: p.scrim,
                    child: child,
                  ),
                  itemBuilder: (context, i) {
                    final t = templates[i];
                    return Column(
                      key: ValueKey(t.id),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SwipeActions(
                          actions: [
                            SwipeAction(
                              label: l10n.delete,
                              icon: CupertinoIcons.delete,
                              color: p.destructive,
                              onTap: () => _archive(t),
                            ),
                          ],
                          child: _TemplateRow(
                            template: t,
                            index: i,
                            onTap: () => context.push(Routes.editTask(t.id)),
                            onToggle: (active) => ref
                                .read(taskServiceProvider)
                                .setTemplateActive(t.id, active),
                          ),
                        ),
                        if (i != templates.length - 1)
                          const HairlineSeparator(
                            indent:
                                DesignTokens.gutter +
                                DesignTokens.iconSize +
                                12,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
            child: Text(
              l10n.dragToReorder,
              style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateRow extends StatelessWidget {
  const _TemplateRow({
    required this.template,
    required this.index,
    required this.onTap,
    required this.onToggle,
  });

  final TaskTemplate template;
  final int index;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  String _repeatLabel(AppLocalizations l10n) => switch (template.repeat.kind) {
    RepeatKind.daily => l10n.repeatDaily,
    RepeatKind.weekdays => l10n.repeatWeekdays,
    RepeatKind.custom => [
      for (final d in template.repeat.weekdays.toList()..sort())
        [
          l10n.weekdayShort1,
          l10n.weekdayShort2,
          l10n.weekdayShort3,
          l10n.weekdayShort4,
          l10n.weekdayShort5,
          l10n.weekdayShort6,
          l10n.weekdayShort7,
        ][d - 1],
    ].join(' '),
  };

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final t = template;
    final subtitle = [
      '${t.target} ${t.unit}',
      _repeatLabel(l10n),
      if (!t.isActive) l10n.pausedTasks,
    ].join(' · ');
    return GroupedRow(
      leading: Opacity(
        opacity: t.isActive ? 1 : 0.4,
        child: TaskIcon(icon: t.icon, colorIndex: t.colorIndex),
      ),
      title: t.name,
      subtitle: subtitle,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: t.isActive ? l10n.pause : l10n.resume,
            child: Switch.adaptive(value: t.isActive, onChanged: onToggle),
          ),
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                CupertinoIcons.line_horizontal_3,
                color: p.secondaryLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
