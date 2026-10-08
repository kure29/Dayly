import 'dart:async';

import '../models.dart';

/// Extension point for features layered on top of task progress — most
/// notably a future game layer (XP, coins, loot …).
///
/// `TaskService` calls every registered hook *after* the change has been
/// committed to the database, in this order:
///
/// 1. [onProgress] for every progress / complete / undo event;
/// 2. [onTaskCompleted] additionally for `complete` events;
/// 3. [onDayCompleted] once per day, when the last task of the day is done
///    (mirrors the single `dayComplete` event).
///
/// Hooks must not mutate tasks themselves; exceptions they throw are caught
/// and reported so they can never break check-ins.
abstract class ProgressHook {
  const ProgressHook();

  FutureOr<void> onProgress(TaskEvent e);

  FutureOr<void> onTaskCompleted(TaskEvent e);

  /// [day] is local midnight of the logical day that was completed.
  FutureOr<void> onDayCompleted(DateTime day);
}

/// Default hook registered in v1: does nothing.
class NoopProgressHook extends ProgressHook {
  const NoopProgressHook();

  @override
  void onProgress(TaskEvent e) {}

  @override
  void onTaskCompleted(TaskEvent e) {}

  @override
  void onDayCompleted(DateTime day) {}
}

/// Feeds a recorded event history into [hook] exactly as `TaskService`
/// would have when the events happened. A game layer added later can use
/// this to compute rewards earned before it was installed.
abstract final class EventReplayer {
  static Future<void> replay(
    Iterable<TaskEvent> events,
    ProgressHook hook,
  ) async {
    final ordered = events.toList()
      ..sort((a, b) {
        final t = a.occurredAt.compareTo(b.occurredAt);
        return t != 0 ? t : a.id.compareTo(b.id);
      });
    for (final e in ordered) {
      switch (e.kind) {
        case EventKind.progress || EventKind.undo:
          await hook.onProgress(e);
        case EventKind.complete:
          await hook.onProgress(e);
          await hook.onTaskCompleted(e);
        case EventKind.dayComplete:
          await hook.onDayCompleted(e.date.toDateTime());
      }
    }
  }
}
