import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/ui/capsule_toast.dart';
import '../../domain/task_service.dart';

/// UI-side wrappers around [TaskService] that add haptics and feedback.
abstract final class TodayActions {
  static Future<void> checkIn(
    BuildContext context,
    WidgetRef ref,
    int dailyTaskId,
  ) async {
    final l10n = context.l10n;
    final result = await ref.read(taskServiceProvider).advance(dailyTaskId);
    if (!result.changed) return;
    unawaited(HapticFeedback.lightImpact());
    if (!context.mounted) return;
    _feedback(context, l10n, result);
  }

  static Future<void> undo(WidgetRef ref, int dailyTaskId) async {
    final result = await ref.read(taskServiceProvider).undo(dailyTaskId);
    if (result.changed) unawaited(HapticFeedback.selectionClick());
  }

  static Future<void> setProgress(
    BuildContext context,
    WidgetRef ref,
    int dailyTaskId,
    int value,
  ) async {
    final l10n = context.l10n;
    final result = await ref
        .read(taskServiceProvider)
        .setProgress(dailyTaskId, value);
    if (!result.changed) return;
    unawaited(HapticFeedback.lightImpact());
    if (!context.mounted) return;
    _feedback(context, l10n, result);
  }

  static void _feedback(
    BuildContext context,
    AppLocalizations l10n,
    ProgressResult result,
  ) {
    if (result.dayCompleted) {
      CapsuleToast.show(
        context,
        l10n.dayCompleteToast,
        icon: CupertinoIcons.checkmark_seal_fill,
      );
    } else if (result.taskCompleted) {
      CapsuleToast.show(
        context,
        l10n.taskCompletedToast(result.task!.name),
        icon: CupertinoIcons.checkmark_circle_fill,
      );
    }
  }
}
