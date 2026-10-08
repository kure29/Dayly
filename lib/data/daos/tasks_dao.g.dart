// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_dao.dart';

// ignore_for_file: type=lint
mixin _$TasksDaoMixin on DatabaseAccessor<AppDatabase> {
  $TaskTemplatesTable get taskTemplates => attachedDatabase.taskTemplates;
  $DailyTasksTable get dailyTasks => attachedDatabase.dailyTasks;
  $TaskEventsTable get taskEvents => attachedDatabase.taskEvents;
  TasksDaoManager get managers => TasksDaoManager(this);
}

class TasksDaoManager {
  final _$TasksDaoMixin _db;
  TasksDaoManager(this._db);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db.attachedDatabase, _db.taskTemplates);
  $$DailyTasksTableTableManager get dailyTasks =>
      $$DailyTasksTableTableManager(_db.attachedDatabase, _db.dailyTasks);
  $$TaskEventsTableTableManager get taskEvents =>
      $$TaskEventsTableTableManager(_db.attachedDatabase, _db.taskEvents);
}
