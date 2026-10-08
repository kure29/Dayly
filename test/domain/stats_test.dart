import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/stats.dart';
import 'package:flutter_test/flutter_test.dart';

DailyTask _t(String date, {required bool done, int progress = -1}) => DailyTask(
  templateId: 1,
  date: LocalDate.parse(date),
  progress: progress >= 0 ? progress : (done ? 10 : 0),
  completedAt: done ? DateTime(2026) : null,
  name: 'x',
  target: 10,
  unit: '',
  step: 1,
  type: TaskType.count,
);

DaySummary _day(String date, int total, int completed) => DaySummary(
  date: LocalDate.parse(date),
  total: total,
  completed: completed,
  progressSum: completed,
  targetSum: total,
);

Map<LocalDate, DaySummary> _days(List<DaySummary> list) => {
  for (final d in list) d.date: d,
};

void main() {
  final today = LocalDate(2026, 10, 8);

  group('streak', () {
    test('counts consecutive fully completed days', () {
      final s = Stats.streak(
        _days([
          _day('2026-10-05', 2, 2),
          _day('2026-10-06', 2, 2),
          _day('2026-10-07', 3, 3),
        ]),
        today,
      );
      expect(s.current, 3);
      expect(s.longest, 3);
    });

    test('an incomplete day resets to zero', () {
      final s = Stats.streak(
        _days([
          _day('2026-10-04', 1, 1),
          _day('2026-10-05', 1, 1),
          _day('2026-10-06', 2, 1),
          _day('2026-10-07', 1, 1),
        ]),
        today,
      );
      expect(s.current, 1);
      expect(s.longest, 2);
    });

    test('days without tasks do not break the streak', () {
      final s = Stats.streak(
        _days([
          _day('2026-10-03', 1, 1),
          _day('2026-10-04', 0, 0), // explicit empty day
          // 10-05 has no data at all (e.g. weekend-only template)
          _day('2026-10-06', 1, 1),
          _day('2026-10-07', 1, 1),
        ]),
        today,
      );
      expect(s.current, 3);
    });

    test('today in progress keeps yesterday’s streak, completing adds 1', () {
      final base = [_day('2026-10-06', 1, 1), _day('2026-10-07', 1, 1)];
      expect(
        Stats.streak(_days([...base, _day('2026-10-08', 2, 1)]), today).current,
        2,
      );
      expect(
        Stats.streak(_days([...base, _day('2026-10-08', 2, 2)]), today).current,
        3,
      );
    });

    test('a missed yesterday means zero', () {
      final s = Stats.streak(
        _days([_day('2026-10-06', 1, 1), _day('2026-10-07', 1, 0)]),
        today,
      );
      expect(s.current, 0);
      expect(s.longest, 1);
    });

    test('empty history', () {
      final s = Stats.streak(const {}, today);
      expect((s.current, s.longest), (0, 0));
    });
  });

  test('day summary ratios', () {
    final s = DaySummary.of(today, [
      _t('2026-10-08', done: true),
      _t('2026-10-08', done: false, progress: 5),
      _t('2026-10-08', done: false),
      _t('2026-10-08', done: false),
    ]);
    expect(s.completionRatio, 0.25);
    expect(s.weightedRatio, closeTo(15 / 40, 1e-9));
    expect(s.isComplete, isFalse);
  });

  test('week and heatmap grids', () {
    final days = Stats.summarize([
      _t('2026-10-05', done: true),
      _t('2026-10-06', done: false),
      _t('2026-10-08', done: true),
      _t('2026-07-20', done: true), // first Monday of the 12-week window
    ]);
    expect(Stats.week(days, today), [1.0, 0.0, null, 1.0, null, null, null]);
    final grid = Stats.heatmap(days, today);
    expect(grid, hasLength(12));
    expect(grid.first.first, 1.0);
    expect(grid.last.sublist(0, 4), [1.0, 0.0, null, 1.0]);
  });

  test('per-template totals and completion rate', () {
    final tpl = TaskTemplate(
      id: 1,
      name: '背单词',
      icon: '',
      colorIndex: 0,
      type: TaskType.count,
      target: 10,
      step: 1,
      unit: '个',
      createdAt: DateTime(2026),
    );
    final s = Stats.perTemplate(
      [tpl],
      [
        _t('2026-10-05', done: true),
        _t('2026-10-06', done: false, progress: 4),
        _t('2026-10-07', done: true),
        _t('2026-10-08', done: false),
      ],
    ).single;
    expect(s.totalAmount, 24);
    expect(s.completionRate, 0.5);
  });
}
