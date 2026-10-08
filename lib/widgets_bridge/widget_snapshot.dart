import 'dart:convert';
import 'dart:ui';

import '../core/theme/app_palette.dart';
import '../core/theme/color_utils.dart';
import '../core/theme/scheme_definition.dart';
import '../core/ui/task_icon.dart';
import '../domain/models.dart';
import '../domain/stats.dart';

/// Keys shared with the native widgets (Android SharedPreferences
/// `HomeWidgetPreferences`, iOS App Group `UserDefaults`).
abstract final class WidgetKeys {
  static const snapshot = 'dq_snapshot';
  static const pending = 'dq_pending';
  static const appGroupId = 'group.com.example.dailyquest';
  static const iOSKind = 'DailyQuestWidget';
  static const androidProviders = [
    'com.example.dailyquest.widget.SmallTaskWidget',
    'com.example.dailyquest.widget.MediumTaskWidget',
    'com.example.dailyquest.widget.LargeTaskWidget',
  ];
  static const checkInHost = 'checkin';
  static const scheme = 'dailyquest';
}

/// Builds the JSON document the native widgets render. Version it with
/// [version] whenever the shape changes; widgets ignore unknown versions.
abstract final class WidgetSnapshot {
  static const int version = 1;

  static Map<String, Object?> build({
    required LocalDate date,
    required List<TodayTask> tasks,
    required int streak,
    required SchemeDefinition scheme,
    required BrightnessMode mode,
    required String title,
    required String emptyText,
    required String staleText,
    required int dayStartHour,
    required DateTime generatedAt,
  }) {
    final summary = DaySummary.of(date, tasks.map((t) => t.task));
    final light = AppPalette.from(scheme, Brightness.light);
    final dark = AppPalette.from(scheme, Brightness.dark);
    return {
      'v': version,
      'date': date.toString(),
      'generatedAt': generatedAt.toIso8601String(),
      'done': summary.completed,
      'total': summary.total,
      'streak': streak,
      'mode': mode.name,
      'title': title,
      'emptyText': emptyText,
      'staleText': staleText,
      // Local wall-clock time at which this snapshot's day ends; widgets show
      // [staleText] after it until the app publishes the new day.
      'nextDayAt': DayClock.startOf(
        date.addDays(1),
        dayStartHour,
      ).toIso8601String(),
      'colors': {'light': _colors(light), 'dark': _colors(dark)},
      'tasks': [
        for (final t in tasks)
          {
            'id': t.task.id,
            'templateId': t.template.id,
            'name': t.task.name,
            'glyph': TaskSymbol.glyphFor(t.icon, t.task.name),
            'sf': TaskSymbol.fromStorage(t.icon)?.sfSymbol,
            'color': {
              'light': _hex(light.taskColor(t.colorIndex)),
              'dark': _hex(dark.taskColor(t.colorIndex)),
            },
            'onColor': {
              'light': _hex(light.onTaskColor(t.colorIndex)),
              'dark': _hex(dark.onTaskColor(t.colorIndex)),
            },
            'progress': t.task.progress,
            'target': t.task.target,
            'step': t.task.step,
            'unit': t.task.unit,
            'done': t.task.isCompleted,
          },
      ],
    };
  }

  static Map<String, String> _colors(AppPalette p) => {
    'background': _hex(p.card),
    'label': _hex(p.label),
    'secondary': _hex(p.secondaryLabel),
    'fill': _hex(p.fill),
    'accent': _hex(p.accent),
    'accentTint': _hex(p.accentTint),
    'onAccent': _hex(p.onAccent),
    'ring': _hex(p.ring),
    'success': _hex(p.success),
  };

  static String _hex(Color c) => ColorUtils.toHex(c);

  static String encode(Map<String, Object?> snapshot) => jsonEncode(snapshot);
}
