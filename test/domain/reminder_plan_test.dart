import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/reminder_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final daily = TaskTemplate(
    id: 1,
    name: 'x',
    icon: '',
    colorIndex: 0,
    type: TaskType.count,
    target: 1,
    step: 1,
    unit: '',
    createdAt: DateTime(2026),
  );
  const on = AppSettings(reminderEnabled: true, reminderMinutes: 20 * 60);

  test('disabled → nothing', () {
    expect(
      ReminderPlanner.plan(
        settings: const AppSettings(),
        now: DateTime(2026, 10, 8, 9),
        remainingToday: 3,
        templates: [daily],
      ),
      isEmpty,
    );
  });

  test('today carries the remaining count, next days are generic', () {
    final plan = ReminderPlanner.plan(
      settings: on,
      now: DateTime(2026, 10, 8, 9),
      remainingToday: 3,
      templates: [daily],
    );
    expect(plan, hasLength(7));
    expect(plan.first.at, DateTime(2026, 10, 8, 20));
    expect(plan.first.remaining, 3);
    expect(plan[1].at, DateTime(2026, 10, 9, 20));
    expect(plan[1].remaining, isNull);
    expect(plan.map((p) => p.id).toSet(), hasLength(7));
  });

  test('skips today when done or already past', () {
    final done = ReminderPlanner.plan(
      settings: on,
      now: DateTime(2026, 10, 8, 9),
      remainingToday: 0,
      templates: [daily],
    );
    expect(done.first.at, DateTime(2026, 10, 9, 20));
    final late = ReminderPlanner.plan(
      settings: on,
      now: DateTime(2026, 10, 8, 21),
      remainingToday: 2,
      templates: [daily],
    );
    expect(late.first.at, DateTime(2026, 10, 9, 20));
  });

  test('after-midnight reminder belongs to the previous logical day', () {
    final plan = ReminderPlanner.plan(
      settings: const AppSettings(
        reminderEnabled: true,
        reminderMinutes: 60, // 01:00
        dayStartHour: 4,
      ),
      now: DateTime(2026, 10, 8, 23),
      remainingToday: 1,
      templates: [daily],
    );
    expect(plan.first.at, DateTime(2026, 10, 9, 1));
    expect(plan.first.remaining, 1);
  });

  test('days without scheduled tasks get no reminder', () {
    final weekend = daily.copyWith(repeat: RepeatRule.custom([6, 7]));
    final plan = ReminderPlanner.plan(
      settings: on,
      now: DateTime(2026, 10, 8, 21), // Thursday evening
      remainingToday: 0,
      templates: [weekend],
    );
    expect(plan.map((p) => p.at.weekday), [DateTime.saturday, DateTime.sunday]);
  });
}
