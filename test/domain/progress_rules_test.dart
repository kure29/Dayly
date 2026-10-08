import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/progress_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final at = DateTime(2026, 10, 8, 9);
  DailyTask task({int progress = 0, int target = 100, int step = 10}) =>
      DailyTask(
        id: 1,
        templateId: 7,
        date: LocalDate(2026, 10, 8),
        progress: progress,
        completedAt: progress >= target ? at : null,
        name: '背单词',
        target: target,
        unit: '个',
        step: step,
        type: TaskType.count,
      );

  group('advance', () {
    test('adds one step and records a progress event', () {
      final c = ProgressRules.advance(task(progress: 40), at: at);
      expect(c.task.progress, 50);
      expect(c.task.completedAt, isNull);
      expect(c.event!.kind, EventKind.progress);
      expect(c.event!.delta, 10);
      expect(c.event!.newProgress, 50);
      expect(c.event!.dailyTaskId, 1);
      expect(c.event!.templateId, 7);
    });

    test('caps at target and completes', () {
      final c = ProgressRules.advance(task(progress: 95), at: at);
      expect(c.task.progress, 100);
      expect(c.task.completedAt, at);
      expect(c.event!.kind, EventKind.complete);
      expect(c.event!.delta, 5);
    });

    test('is a no-op once completed', () {
      final c = ProgressRules.advance(task(progress: 100), at: at);
      expect(c.changed, isFalse);
      expect(c.task.progress, 100);
    });

    test('records the source', () {
      final c = ProgressRules.advance(
        task(),
        at: at,
        source: EventSource.widget,
      );
      expect(c.event!.source, EventSource.widget);
    });

    test('once-type task completes in one step', () {
      final c = ProgressRules.advance(task(target: 1, step: 1), at: at);
      expect(c.task.isCompleted, isTrue);
      expect(c.event!.kind, EventKind.complete);
    });
  });

  group('undo', () {
    test('steps back once', () {
      final c = ProgressRules.undo(task(progress: 40), at: at);
      expect(c.task.progress, 30);
      expect(c.event!.kind, EventKind.undo);
      expect(c.event!.delta, -10);
    });

    test('leaving completion clears completedAt', () {
      final c = ProgressRules.undo(task(progress: 100), at: at);
      expect(c.task.progress, 90);
      expect(c.task.completedAt, isNull);
      expect(c.event!.kind, EventKind.undo);
    });

    test('floors at zero and is a no-op at zero', () {
      expect(ProgressRules.undo(task(progress: 5), at: at).task.progress, 0);
      expect(ProgressRules.undo(task(), at: at).changed, isFalse);
    });
  });

  group('setProgress', () {
    test('clamps into range', () {
      expect(ProgressRules.setProgress(task(), 250, at: at).task.progress, 100);
      expect(
        ProgressRules.setProgress(task(progress: 50), -3, at: at).task.progress,
        0,
      );
    });

    test('picks the event kind from the direction', () {
      expect(
        ProgressRules.setProgress(task(), 30, at: at).event!.kind,
        EventKind.progress,
      );
      expect(
        ProgressRules.setProgress(task(), 100, at: at).event!.kind,
        EventKind.complete,
      );
      expect(
        ProgressRules.setProgress(task(progress: 60), 20, at: at).event!.kind,
        EventKind.undo,
      );
      expect(
        ProgressRules.setProgress(task(progress: 60), 60, at: at).changed,
        isFalse,
      );
    });
  });

  test('event deltas replay to the final progress', () {
    var t = task();
    var sum = 0;
    for (final op in ['+', '+', '+', '-', 's80', '+', '+', '+', '-']) {
      final ProgressChange c;
      if (op == '+') {
        c = ProgressRules.advance(t, at: at);
      } else if (op == '-') {
        c = ProgressRules.undo(t, at: at);
      } else {
        c = ProgressRules.setProgress(t, int.parse(op.substring(1)), at: at);
      }
      sum += c.event?.delta ?? 0;
      t = c.task;
    }
    expect(sum, t.progress);
  });
}
