import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'database.dart';

extension TemplateRowMapper on TemplateRow {
  TaskTemplate toDomain() => TaskTemplate(
    id: id,
    name: name,
    icon: icon,
    colorIndex: colorIndex,
    type: TaskType.parse(type),
    target: target,
    step: step,
    unit: unit,
    repeat: RepeatRule.fromStorage(repeatKind, repeatDays),
    isActive: isActive,
    sortOrder: sortOrder,
    createdAt: createdAt,
    archivedAt: archivedAt,
  );
}

extension TemplateToCompanion on TaskTemplate {
  TaskTemplatesCompanion toCompanion({bool withId = false}) =>
      TaskTemplatesCompanion(
        id: withId ? Value(id) : const Value.absent(),
        name: Value(name),
        icon: Value(icon),
        colorIndex: Value(colorIndex),
        type: Value(type.name),
        target: Value(target),
        step: Value(step),
        unit: Value(unit),
        repeatKind: Value(repeat.kind.name),
        repeatDays: Value(repeat.weekdayMask),
        isActive: Value(isActive),
        sortOrder: Value(sortOrder),
        createdAt: Value(createdAt),
        archivedAt: Value(archivedAt),
      );
}

extension DailyTaskRowMapper on DailyTaskRow {
  DailyTask toDomain() => DailyTask(
    id: id,
    templateId: templateId,
    date: LocalDate.parse(date),
    progress: progress,
    completedAt: completedAt,
    name: name,
    target: target,
    unit: unit,
    step: step,
    type: TaskType.parse(type),
  );
}

extension DailyTaskToCompanion on DailyTask {
  DailyTasksCompanion toCompanion({bool withId = false}) => DailyTasksCompanion(
    id: withId ? Value(id) : const Value.absent(),
    templateId: Value(templateId),
    date: Value(date.toString()),
    progress: Value(progress),
    completedAt: Value(completedAt),
    name: Value(name),
    target: Value(target),
    unit: Value(unit),
    step: Value(step),
    type: Value(type.name),
  );
}

extension TaskEventRowMapper on TaskEventRow {
  TaskEvent toDomain() => TaskEvent(
    id: id,
    dailyTaskId: dailyTaskId,
    templateId: templateId,
    date: LocalDate.parse(date),
    delta: delta,
    newProgress: newProgress,
    kind: EventKind.parse(kind),
    source: EventSource.parse(source),
    occurredAt: occurredAt,
  );
}

extension TaskEventToCompanion on TaskEvent {
  TaskEventsCompanion toCompanion({bool withId = false}) => TaskEventsCompanion(
    id: withId ? Value(id) : const Value.absent(),
    dailyTaskId: Value(dailyTaskId),
    templateId: Value(templateId),
    date: Value(date.toString()),
    delta: Value(delta),
    newProgress: Value(newProgress),
    kind: Value(kind.name),
    source: Value(source.name),
    occurredAt: Value(occurredAt),
  );
}

extension SettingsRowMapper on SettingsRow {
  AppSettings toDomain() => AppSettings(
    schemeId: schemeId,
    customAccent: customAccent,
    brightnessMode: BrightnessMode.parse(brightnessMode),
    dayStartHour: dayStartHour,
    reminderEnabled: reminderEnabled,
    reminderMinutes: reminderMinutes,
  );
}

extension SettingsToCompanion on AppSettings {
  SettingsEntriesCompanion toCompanion() => SettingsEntriesCompanion(
    id: const Value(1),
    schemeId: Value(schemeId),
    customAccent: Value(customAccent),
    brightnessMode: Value(brightnessMode.name),
    dayStartHour: Value(dayStartHour),
    reminderEnabled: Value(reminderEnabled),
    reminderMinutes: Value(reminderMinutes),
  );
}
