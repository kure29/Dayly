import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/app_sheet.dart';
import '../../core/ui/capsule_button.dart';
import '../../domain/models.dart';

/// Asks for an exact progress value (long-press on a task). Returns `null`
/// when cancelled.
Future<int?> showProgressInputSheet(BuildContext context, DailyTask task) {
  return showAppSheet<int>(
    context,
    title: context.l10n.setProgressTitle,
    builder: (_) => _ProgressInput(task: task),
  );
}

class _ProgressInput extends StatefulWidget {
  const _ProgressInput({required this.task});

  final DailyTask task;

  @override
  State<_ProgressInput> createState() => _ProgressInputState();
}

class _ProgressInputState extends State<_ProgressInput> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.task.progress}',
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 0 || value > widget.task.target) {
      setState(() => _error = context.l10n.setProgressHint(widget.task.target));
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.task.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.subhead.copyWith(color: p.secondaryLabel),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('progress-input'),
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.largeTitle.copyWith(color: p.label),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.setProgressHint(widget.task.target),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                Text(
                  '/ ${widget.task.target} ${widget.task.unit}',
                  style: AppTextStyles.body.copyWith(color: p.secondaryLabel),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.footnote.copyWith(color: p.destructive),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CapsuleButton(
                  label: l10n.cancel,
                  style: CapsuleStyle.gray,
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CapsuleButton(
                  label: l10n.save,
                  style: CapsuleStyle.filled,
                  expand: true,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
