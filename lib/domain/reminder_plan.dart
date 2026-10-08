import 'models.dart';

/// One notification to schedule.
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.at,
    required this.remaining,
  });

  /// Stable notification id (base + day offset).
  final int id;
  final DateTime at;

  /// Unfinished tasks for "today"; `null` for future days (generic text).
  final int? remaining;
}

/// Plans the daily "unfinished tasks" reminders for the next [days] days.
///
/// Today's reminder carries the live number of unfinished tasks and is
/// skipped when everything is done or the time has passed. Future days get
/// a generic reminder on days that have scheduled tasks; the app re-plans on
/// every change/launch, so a future day the user completes early is
/// cancelled when that day's plan is rebuilt.
abstract final class ReminderPlanner {
  static const int baseId = 4100;
  static const int days = 7;

  static List<PlannedReminder> plan({
    required AppSettings settings,
    required DateTime now,
    required int remainingToday,
    required List<TaskTemplate> templates,
  }) {
    if (!settings.reminderEnabled) return const [];
    final startHour = settings.dayStartHour;
    final today = DayClock.logicalDate(now, startHour);
    // Minutes after the logical day start (handles reminders after midnight
    // that still belong to the previous logical day).
    final offset = (settings.reminderMinutes - startHour * 60) % (24 * 60);
    final out = <PlannedReminder>[];
    for (var i = 0; i < days; i++) {
      final day = today.addDays(i);
      final at = DayClock.startOf(
        day,
        startHour,
      ).add(Duration(minutes: offset));
      if (!at.isAfter(now)) continue;
      if (i == 0) {
        if (remainingToday <= 0) continue;
        out.add(PlannedReminder(id: baseId, at: at, remaining: remainingToday));
      } else {
        final scheduled = templates.any(
          (t) => t.isActive && !t.isArchived && t.repeat.appliesOn(day),
        );
        if (!scheduled) continue;
        out.add(PlannedReminder(id: baseId + i, at: at, remaining: null));
      }
    }
    return out;
  }

  static Iterable<int> get allIds sync* {
    for (var i = 0; i < days; i++) {
      yield baseId + i;
    }
  }
}
