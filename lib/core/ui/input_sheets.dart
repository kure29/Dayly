import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import 'app_sheet.dart';
import 'capsule_button.dart';

/// Single text field in a sheet. Returns the trimmed value or `null`.
Future<String?> showTextInputSheet(
  BuildContext context, {
  required String title,
  required String initial,
  int? maxCharacters,
}) {
  return showAppSheet<String>(
    context,
    title: title,
    builder: (_) => _TextInput(initial: initial, maxCharacters: maxCharacters),
  );
}

class _TextInput extends StatefulWidget {
  const _TextInput({required this.initial, this.maxCharacters});

  final String initial;
  final int? maxCharacters;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    var v = _c.text.trim();
    if (v.isEmpty) return;
    final max = widget.maxCharacters;
    if (max != null && v.characters.length > max) {
      v = v.characters.take(max).toString();
    }
    Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _c,
              autofocus: true,
              style: AppTextStyles.body.copyWith(color: p.label),
              decoration: const InputDecoration(border: InputBorder.none),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(height: 16),
          CapsuleButton(
            label: context.l10n.save,
            style: CapsuleStyle.filled,
            expand: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Wheel picker over [values]. Returns the chosen value or `null`.
Future<T?> showWheelPickerSheet<T>(
  BuildContext context, {
  required String title,
  required List<T> values,
  required T initial,
  required String Function(T) label,
}) {
  var selected = initial;
  return showAppSheet<T>(
    context,
    title: title,
    builder: (sheetContext) {
      final p = sheetContext.palette;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(
                  initialItem: values.indexOf(initial).clamp(0, values.length),
                ),
                onSelectedItemChanged: (i) => selected = values[i],
                children: [
                  for (final v in values)
                    Center(
                      child: Text(
                        label(v),
                        style: AppTextStyles.body.copyWith(color: p.label),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CapsuleButton(
              label: sheetContext.l10n.confirm,
              style: CapsuleStyle.filled,
              expand: true,
              onPressed: () => Navigator.of(sheetContext).pop(selected),
            ),
          ],
        ),
      );
    },
  );
}

/// Time-of-day wheel. Returns minutes after midnight or `null`.
Future<int?> showTimePickerSheet(
  BuildContext context, {
  required String title,
  required int initialMinutes,
}) {
  var minutes = initialMinutes;
  return showAppSheet<int>(
    context,
    title: title,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 180,
            child: CupertinoTheme(
              data: CupertinoTheme.of(sheetContext).copyWith(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: AppTextStyles.title.copyWith(
                    color: sheetContext.palette.label,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(
                  2000,
                  1,
                  1,
                  initialMinutes ~/ 60,
                  initialMinutes % 60,
                ),
                onDateTimeChanged: (d) => minutes = d.hour * 60 + d.minute,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CapsuleButton(
            label: sheetContext.l10n.confirm,
            style: CapsuleStyle.filled,
            expand: true,
            onPressed: () => Navigator.of(sheetContext).pop(minutes),
          ),
        ],
      ),
    ),
  );
}
