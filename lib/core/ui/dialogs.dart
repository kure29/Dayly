import 'package:flutter/cupertino.dart';

import '../l10n/l10n.dart';

/// iOS alert with Cancel + a confirm action. Resolves to `true` on confirm.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: destructive,
          isDefaultAction: !destructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Alert with several labelled options plus Cancel. Resolves to the chosen
/// value, or `null` when cancelled.
Future<T?> showChoiceDialog<T>(
  BuildContext context, {
  required String title,
  String? message,
  required Map<T, String> options,
}) {
  return showCupertinoDialog<T>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        for (final e in options.entries)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(e.key),
            child: Text(e.value),
          ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
      ],
    ),
  );
}
