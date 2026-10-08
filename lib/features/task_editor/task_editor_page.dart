import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/ui/dialogs.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/segmented.dart';
import '../../core/ui/task_icon.dart';
import '../../domain/models.dart';
import '../../domain/template_validation.dart';
import 'builtin_templates.dart';

/// Create ([templateId] == null) or edit a [TaskTemplate].
class TaskEditorPage extends ConsumerStatefulWidget {
  const TaskEditorPage({super.key, this.templateId});

  final int? templateId;

  @override
  ConsumerState<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends ConsumerState<TaskEditorPage> {
  final _name = TextEditingController();
  final _icon = TextEditingController();
  final _target = TextEditingController(text: '1');
  final _step = TextEditingController(text: '1');
  final _unit = TextEditingController();

  TaskTemplate? _original;
  bool _loading = true;
  bool _saving = false;
  int _colorIndex = 0;
  TaskType _type = TaskType.count;
  RepeatKind _repeatKind = RepeatKind.daily;
  Set<int> _customDays = {1, 2, 3, 4, 5, 6, 7};
  Set<TemplateError> _errors = {};
  bool _submitted = false;

  bool get _isNew => widget.templateId == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.templateId;
    if (id != null) {
      final t = await ref.read(taskRepositoryProvider).templateById(id);
      if (t != null) _fill(t);
      _original = t;
    } else {
      _unit.text = '';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _fill(TaskTemplate t) {
    _name.text = t.name;
    _icon.text = TaskSymbol.fromStorage(t.icon) == null ? t.icon : '';
    _symbol = TaskSymbol.fromStorage(t.icon)?.key;
    _colorIndex = t.colorIndex;
    _type = t.type;
    _target.text = '${t.target}';
    _step.text = '${t.step}';
    _unit.text = t.unit;
    _repeatKind = t.repeat.kind;
    _customDays = t.repeat.weekdays;
  }

  String? _symbol;

  void _applyBuiltin(BuiltinTemplate b) {
    setState(() {
      _fill(b.toTemplate(DateTime.now()));
      _revalidate();
    });
  }

  @override
  void dispose() {
    for (final c in [_name, _icon, _target, _step, _unit]) {
      c.dispose();
    }
    super.dispose();
  }

  RepeatRule get _repeat => switch (_repeatKind) {
    RepeatKind.daily => const RepeatRule.daily(),
    RepeatKind.weekdays => const RepeatRule.weekdays(),
    RepeatKind.custom => RepeatRule.custom(_customDays),
  };

  int? get _targetValue =>
      _type == TaskType.once ? 1 : int.tryParse(_target.text.trim());

  int? get _stepValue =>
      _type == TaskType.once ? 1 : int.tryParse(_step.text.trim());

  void _revalidate() {
    if (!_submitted) return;
    _errors = TemplateValidation.validate(
      name: _name.text,
      target: _targetValue,
      step: _stepValue,
      repeat: _repeat,
    );
  }

  String get _iconValue {
    final glyph = _icon.text.trim();
    if (glyph.isNotEmpty) return glyph.characters.first;
    if (_symbol != null) return '${TaskSymbol.prefix}$_symbol';
    final name = _name.text.trim();
    return name.isEmpty ? '•' : name.characters.first;
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    setState(() {
      _submitted = true;
      _revalidate();
    });
    if (_errors.isNotEmpty) {
      unawaited(HapticFeedback.mediumImpact());
      return;
    }
    final service = ref.read(taskServiceProvider);
    final draft = TaskTemplate(
      id: _original?.id ?? 0,
      name: _name.text.trim(),
      icon: _iconValue,
      colorIndex: _colorIndex,
      type: _type,
      target: _targetValue!,
      step: _stepValue!,
      unit: _unit.text.trim().isEmpty
          ? _defaultUnit(l10n, _type)
          : _unit.text.trim(),
      repeat: _repeat,
      isActive: _original?.isActive ?? true,
      sortOrder: _original?.sortOrder ?? 0,
      createdAt: _original?.createdAt ?? service.now(),
    );
    setState(() => _saving = true);
    try {
      if (_original == null) {
        await service.createTemplate(draft);
      } else {
        var sync = false;
        if (_snapshotChanged(_original!, draft) &&
            await service.hasTodayTask(draft.id)) {
          if (!mounted) return;
          final choice = await showChoiceDialog<bool>(
            context,
            title: l10n.syncToTodayTitle,
            message: l10n.syncToTodayMessage(draft.name),
            options: {true: l10n.syncToTodayYes, false: l10n.syncToTodayNo},
          );
          if (choice == null) return;
          sync = choice;
        }
        await service.updateTemplate(draft, syncToday: sync);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  static bool _snapshotChanged(TaskTemplate a, TaskTemplate b) =>
      a.name != b.name ||
      a.target != b.target ||
      a.step != b.step ||
      a.unit != b.unit ||
      a.type != b.type;

  static String _defaultUnit(AppLocalizations l10n, TaskType type) =>
      switch (type) {
        TaskType.count => l10n.unitCount,
        TaskType.once => l10n.unitTimes,
        TaskType.duration => l10n.unitMinutes,
      };

  Future<void> _archive() async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l10n.archiveConfirmTitle(_original!.name),
      message: l10n.archiveConfirmMessage,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(taskServiceProvider).archiveTemplate(_original!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    return DetailPage(
      title: _isNew ? l10n.newTask : l10n.editTask,
      leading: NavTextButton(
        label: l10n.cancel,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        NavTextButton(
          key: const ValueKey('editor-save'),
          label: l10n.save,
          bold: true,
          onPressed: _saving || _loading ? null : _save,
        ),
      ],
      body: _loading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isNew) ...[
                    _SectionLabel(l10n.templates),
                    _BuiltinStrip(onPick: _applyBuiltin),
                    const SizedBox(height: 24),
                  ],
                  GroupedSection(
                    separatorIndent: DesignTokens.gutter,
                    children: [
                      _FieldRow(
                        label: l10n.fieldName,
                        child: _InlineField(
                          key: const ValueKey('field-name'),
                          controller: _name,
                          hint: l10n.fieldNameHint,
                          error: _errors.contains(TemplateError.nameLength),
                          onChanged: (_) => setState(_revalidate),
                        ),
                      ),
                    ],
                  ),
                  _ErrorText(
                    show: _errors.contains(TemplateError.nameLength),
                    text: l10n.errorNameLength,
                  ),
                  GroupedSection(
                    header: l10n.fieldIcon,
                    separatorIndent: DesignTokens.gutter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.gutter),
                        child: Row(
                          children: [
                            TaskIcon(
                              icon: _iconValue,
                              colorIndex: _colorIndex,
                              size: 44,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InlineField(
                                controller: _icon,
                                hint: l10n.fieldIconHint,
                                textAlign: TextAlign.start,
                                onChanged: (_) =>
                                    setState(() => _symbol = null),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.gutter),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final s in TaskSymbol.all)
                              _SymbolButton(
                                symbol: s,
                                selected:
                                    _icon.text.isEmpty && _symbol == s.key,
                                onTap: () => setState(() {
                                  _icon.clear();
                                  _symbol = s.key;
                                }),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(DesignTokens.gutter),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < p.taskColors.length; i++)
                              _ColorDot(
                                color: p.taskColor(i),
                                selected: i == _colorIndex,
                                onTap: () => setState(() => _colorIndex = i),
                                semanticLabel: '${l10n.fieldColor} ${i + 1}',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GroupedSection(
                    header: l10n.fieldType,
                    separatorIndent: DesignTokens.gutter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Segmented<TaskType>(
                          value: _type,
                          onChanged: (t) => setState(() {
                            _type = t;
                            if (t == TaskType.once) {
                              _target.text = '1';
                              _step.text = '1';
                            }
                            _unit.text = _defaultUnit(l10n, t);
                            _revalidate();
                          }),
                          segments: {
                            TaskType.count: l10n.typeCount,
                            TaskType.once: l10n.typeOnce,
                            TaskType.duration: l10n.typeDuration,
                          },
                        ),
                      ),
                      if (_type != TaskType.once) ...[
                        _FieldRow(
                          label: l10n.fieldTarget,
                          child: _InlineField(
                            key: const ValueKey('field-target'),
                            controller: _target,
                            number: true,
                            error: _errors.contains(TemplateError.target),
                            onChanged: (_) => setState(_revalidate),
                          ),
                        ),
                        _FieldRow(
                          label: l10n.fieldStep,
                          child: _InlineField(
                            key: const ValueKey('field-step'),
                            controller: _step,
                            number: true,
                            error: _errors.contains(TemplateError.step),
                            onChanged: (_) => setState(_revalidate),
                          ),
                        ),
                      ],
                      _FieldRow(
                        label: l10n.fieldUnit,
                        child: _InlineField(
                          key: const ValueKey('field-unit'),
                          controller: _unit,
                          hint: _defaultUnit(l10n, _type),
                        ),
                      ),
                    ],
                  ),
                  _ErrorText(
                    show: _errors.contains(TemplateError.target),
                    text: l10n.errorTarget,
                  ),
                  _ErrorText(
                    show: _errors.contains(TemplateError.step),
                    text: l10n.errorStep,
                  ),
                  GroupedSection(
                    header: l10n.fieldRepeat,
                    separatorIndent: DesignTokens.gutter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Segmented<RepeatKind>(
                          value: _repeatKind,
                          onChanged: (k) => setState(() {
                            _repeatKind = k;
                            _revalidate();
                          }),
                          segments: {
                            RepeatKind.daily: l10n.repeatDaily,
                            RepeatKind.weekdays: l10n.repeatWeekdays,
                            RepeatKind.custom: l10n.repeatCustom,
                          },
                        ),
                      ),
                      if (_repeatKind == RepeatKind.custom)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var d = 1; d <= 7; d++)
                                _DayToggle(
                                  label: _weekdayLabel(l10n, d),
                                  selected: _customDays.contains(d),
                                  onTap: () => setState(() {
                                    _customDays = {..._customDays};
                                    if (!_customDays.remove(d)) {
                                      _customDays.add(d);
                                    }
                                    _revalidate();
                                  }),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  _ErrorText(
                    show: _errors.contains(TemplateError.repeat),
                    text: l10n.errorRepeat,
                  ),
                  if (!_isNew && _original != null)
                    GroupedSection(
                      separatorIndent: DesignTokens.gutter,
                      children: [
                        GroupedRow(
                          title: l10n.delete,
                          destructive: true,
                          onTap: _archive,
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  static String _weekdayLabel(AppLocalizations l10n, int d) => switch (d) {
    1 => l10n.weekdayShort1,
    2 => l10n.weekdayShort2,
    3 => l10n.weekdayShort3,
    4 => l10n.weekdayShort4,
    5 => l10n.weekdayShort5,
    6 => l10n.weekdayShort6,
    _ => l10n.weekdayShort7,
  };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
    child: Text(
      text,
      style: AppTextStyles.footnote.copyWith(
        color: context.palette.secondaryLabel,
      ),
    ),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.show, required this.text});

  final bool show;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Text(
        text,
        style: AppTextStyles.footnote.copyWith(
          color: context.palette.destructive,
        ),
      ),
    );
  }
}

class _BuiltinStrip extends StatelessWidget {
  const _BuiltinStrip({required this.onPick});

  final ValueChanged<BuiltinTemplate> onPick;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final items = builtinTemplates(context.l10n);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final b = items[i];
          return GestureDetector(
            key: ValueKey('builtin-$i'),
            onTap: () => onPick(b),
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
              decoration: ShapeDecoration(
                color: p.card,
                shape: const StadiumBorder(),
              ),
              child: Row(
                children: [
                  TaskIcon(icon: b.icon, colorIndex: b.colorIndex, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    b.name,
                    style: AppTextStyles.subhead.copyWith(color: p.label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: context.palette.label,
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _InlineField extends StatelessWidget {
  const _InlineField({
    super.key,
    required this.controller,
    this.hint,
    this.number = false,
    this.error = false,
    this.onChanged,
    this.textAlign = TextAlign.end,
  });

  final TextEditingController controller;
  final String? hint;
  final bool number;
  final bool error;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: textAlign,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      inputFormatters: number
          ? [FilteringTextInputFormatter.digitsOnly]
          : const [],
      style: AppTextStyles.body.copyWith(
        color: error ? p.destructive : p.label,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: p.secondaryLabel),
      ),
    );
  }
}

class _SymbolButton extends StatelessWidget {
  const _SymbolButton({
    required this.symbol,
    required this.selected,
    required this.onTap,
  });

  final TaskSymbol symbol;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: symbol.key,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? p.accentTint : p.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? p.accent : p.separator,
              width: selected ? 1.5 : 0.5,
            ),
          ),
          child: Icon(
            symbol.icon,
            size: 20,
            color: selected ? p.accent : p.secondaryLabel,
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
    required this.semanticLabel,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? color : p.card.withValues(alpha: 0),
              width: 2,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _DayToggle extends StatelessWidget {
  const _DayToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? p.accent : p.fill,
          ),
          child: Text(
            label,
            style: AppTextStyles.subhead.copyWith(
              color: selected ? p.onAccent : p.label,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
