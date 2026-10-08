import 'models.dart';

/// Result of applying a rule to a [DailyTask]. [event] is `null` when nothing
/// changed (e.g. advancing a finished task).
class ProgressChange {
  const ProgressChange(this.task, this.event);

  final DailyTask task;
  final TaskEvent? event;

  bool get changed => event != null;
}

/// Pure progress rules. They never touch storage; `TaskService` persists the
/// returned task and event.
abstract final class ProgressRules {
  /// progress += step, capped at target. Reaching the target stamps
  /// `completedAt` and yields a [EventKind.complete] event.
  static ProgressChange advance(
    DailyTask task, {
    required DateTime at,
    EventSource source = EventSource.app,
  }) {
    final step = task.step < 1 ? 1 : task.step;
    return _moveTo(task, task.progress + step, at: at, source: source);
  }

  /// Steps back once (progress -= step, floored at 0). Leaving the completed
  /// state clears `completedAt`. Always yields [EventKind.undo].
  static ProgressChange undo(
    DailyTask task, {
    required DateTime at,
    EventSource source = EventSource.app,
  }) {
    final step = task.step < 1 ? 1 : task.step;
    return _moveTo(task, task.progress - step, at: at, source: source);
  }

  /// Sets an explicit value (long-press input), clamped to `0…target`.
  static ProgressChange setProgress(
    DailyTask task,
    int value, {
    required DateTime at,
    EventSource source = EventSource.app,
  }) => _moveTo(task, value, at: at, source: source);

  /// Replaces the snapshot fields of today's task after a template edit the
  /// user chose to "sync to today". Progress is clamped to the new target and
  /// the completion state re-evaluated; an event is written only if progress
  /// or completion changed.
  static ProgressChange resnapshot(
    DailyTask task,
    TaskTemplate template, {
    required DateTime at,
  }) {
    final updated = task.copyWith(
      name: template.name,
      target: template.target,
      unit: template.unit,
      step: template.step,
      type: template.type,
    );
    final base = _moveTo(
      updated,
      task.progress,
      at: at,
      source: EventSource.app,
    );
    return base.changed ? base : ProgressChange(updated, null);
  }

  static ProgressChange _moveTo(
    DailyTask task,
    int requested, {
    required DateTime at,
    required EventSource source,
  }) {
    final target = task.target < 1 ? 1 : task.target;
    final next = requested.clamp(0, target);
    final wasDone = task.isCompleted;
    final isDone = next >= target;
    if (next == task.progress && wasDone == isDone) {
      return ProgressChange(task, null);
    }
    final kind = !wasDone && isDone
        ? EventKind.complete
        : (next < task.progress || (wasDone && !isDone))
        ? EventKind.undo
        : EventKind.progress;
    final updated = task.copyWith(
      progress: next,
      completedAt: () => isDone ? (wasDone ? task.completedAt : at) : null,
    );
    return ProgressChange(
      updated,
      TaskEvent(
        dailyTaskId: task.id,
        templateId: task.templateId,
        date: task.date,
        delta: next - task.progress,
        newProgress: next,
        kind: kind,
        source: source,
        occurredAt: at,
      ),
    );
  }
}
