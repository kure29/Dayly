import 'package:drift/drift.dart';

@DataClassName('TemplateRow')
class TaskTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get colorIndex => integer()();

  /// `TaskType.name`.
  TextColumn get type => text()();
  IntColumn get target => integer()();
  IntColumn get step => integer()();
  TextColumn get unit => text()();

  /// `RepeatKind.name`.
  TextColumn get repeatKind => text()();

  /// Bit 0 = Monday … bit 6 = Sunday.
  IntColumn get repeatDays => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@DataClassName('DailyTaskRow')
@TableIndex(name: 'daily_tasks_date', columns: {#date})
class DailyTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId => integer().references(TaskTemplates, #id)();

  /// `yyyy-MM-dd` logical date.
  TextColumn get date => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Snapshot of the template at generation time.
  TextColumn get name => text()();
  IntColumn get target => integer()();
  TextColumn get unit => text()();
  IntColumn get step => integer()();
  TextColumn get type => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {templateId, date},
  ];
}

@DataClassName('TaskEventRow')
@TableIndex(name: 'task_events_date', columns: {#date})
@TableIndex(name: 'task_events_daily_task', columns: {#dailyTaskId})
class TaskEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Null for day-level events. No FK so the log survives task deletion.
  IntColumn get dailyTaskId => integer().nullable()();
  IntColumn get templateId => integer().nullable()();
  TextColumn get date => text()();
  IntColumn get delta => integer()();
  IntColumn get newProgress => integer()();

  /// `EventKind.name`.
  TextColumn get kind => text()();

  /// `EventSource.name`.
  TextColumn get source => text()();
  DateTimeColumn get occurredAt => dateTime()();
}

/// Single-row table (id = 1).
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get nickname => text()();
  TextColumn get avatarChar => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row table (id = 1).
@DataClassName('SettingsRow')
class SettingsEntries extends Table {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get schemeId => text()();
  IntColumn get customAccent => integer().nullable()();
  TextColumn get brightnessMode => text()();
  IntColumn get dayStartHour => integer()();
  BoolColumn get reminderEnabled => boolean()();
  IntColumn get reminderMinutes => integer()();
  BoolColumn get seeded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
