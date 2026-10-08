import 'models.dart';

/// Aggregate progress of one day.
class DaySummary {
  const DaySummary({
    required this.date,
    required this.total,
    required this.completed,
    required this.progressSum,
    required this.targetSum,
  });

  factory DaySummary.of(LocalDate date, Iterable<DailyTask> tasks) {
    var total = 0, completed = 0, progress = 0, target = 0;
    for (final t in tasks) {
      total++;
      if (t.isCompleted) completed++;
      progress += t.progress.clamp(0, t.target);
      target += t.target;
    }
    return DaySummary(
      date: date,
      total: total,
      completed: completed,
      progressSum: progress,
      targetSum: target,
    );
  }

  final LocalDate date;
  final int total;
  final int completed;
  final int progressSum;
  final int targetSum;

  bool get hasTasks => total > 0;
  bool get isComplete => total > 0 && completed == total;

  /// 今日进度: completed tasks / tasks of the day.
  double get completionRatio => total == 0 ? 0 : completed / total;

  /// Completion weighted by target amount: Σprogress / Σtarget.
  double get weightedRatio => targetSum == 0 ? 0 : progressSum / targetSum;
}

class StreakInfo {
  const StreakInfo({required this.current, required this.longest});

  final int current;
  final int longest;
}

abstract final class Stats {
  /// Groups [tasks] by date into [DaySummary]s.
  static Map<LocalDate, DaySummary> summarize(Iterable<DailyTask> tasks) {
    final byDate = <LocalDate, List<DailyTask>>{};
    for (final t in tasks) {
      (byDate[t.date] ??= []).add(t);
    }
    return {
      for (final e in byDate.entries) e.key: DaySummary.of(e.key, e.value),
    };
  }

  /// Streak rules:
  /// * a fully completed day adds 1;
  /// * a day with tasks that is not fully completed resets to 0 — except
  ///   [today], which is still in progress and never breaks the streak;
  /// * days without tasks (or without data) neither add nor break.
  static StreakInfo streak(Map<LocalDate, DaySummary> days, LocalDate today) {
    if (days.isEmpty) return const StreakInfo(current: 0, longest: 0);
    final dates = days.keys.where((d) => !d.isAfter(today)).toList()..sort();
    var run = 0, longest = 0;
    for (final date in dates) {
      final day = days[date]!;
      if (!day.hasTasks) continue;
      if (day.isComplete) {
        run++;
        if (run > longest) longest = run;
      } else if (date != today) {
        run = 0;
      }
    }
    return StreakInfo(current: run, longest: longest);
  }

  /// Completion ratio for each day of the week containing [today]
  /// (Monday first). `null` = no tasks / future day.
  static List<double?> week(Map<LocalDate, DaySummary> days, LocalDate today) {
    final monday = today.startOfWeek;
    return [
      for (var i = 0; i < 7; i++)
        _ratio(days[monday.addDays(i)], monday.addDays(i), today),
    ];
  }

  /// [weeks]×7 grid of completion ratios ending with the current week.
  /// Outer list = weeks (oldest first), inner = Monday…Sunday.
  static List<List<double?>> heatmap(
    Map<LocalDate, DaySummary> days,
    LocalDate today, {
    int weeks = 12,
  }) {
    final firstMonday = today.startOfWeek.addDays(-7 * (weeks - 1));
    return [
      for (var w = 0; w < weeks; w++)
        [
          for (var d = 0; d < 7; d++)
            _ratio(
              days[firstMonday.addDays(w * 7 + d)],
              firstMonday.addDays(w * 7 + d),
              today,
            ),
        ],
    ];
  }

  static double? _ratio(DaySummary? s, LocalDate date, LocalDate today) {
    if (date.isAfter(today) || s == null || !s.hasTasks) return null;
    return s.completionRatio;
  }

  /// Lifetime totals per template.
  static List<TemplateStats> perTemplate(
    Iterable<TaskTemplate> templates,
    Iterable<DailyTask> tasks,
  ) {
    final byTemplate = <int, List<DailyTask>>{};
    for (final t in tasks) {
      (byTemplate[t.templateId] ??= []).add(t);
    }
    return [
      for (final tpl in templates)
        TemplateStats.of(tpl, byTemplate[tpl.id] ?? const []),
    ];
  }
}

class TemplateStats {
  const TemplateStats({
    required this.template,
    required this.totalAmount,
    required this.scheduledDays,
    required this.completedDays,
  });

  factory TemplateStats.of(TaskTemplate template, List<DailyTask> tasks) {
    var amount = 0, done = 0;
    for (final t in tasks) {
      amount += t.progress;
      if (t.isCompleted) done++;
    }
    return TemplateStats(
      template: template,
      totalAmount: amount,
      scheduledDays: tasks.length,
      completedDays: done,
    );
  }

  final TaskTemplate template;

  /// Σ progress over all days (e.g. 2,340 words).
  final int totalAmount;
  final int scheduledDays;
  final int completedDays;

  double get completionRate =>
      scheduledDays == 0 ? 0 : completedDays / scheduledDays;
}
