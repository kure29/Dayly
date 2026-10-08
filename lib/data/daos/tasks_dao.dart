import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'tasks_dao.g.dart';

/// Raw queries over templates, daily tasks and events.
@DriftAccessor(tables: [TaskTemplates, DailyTasks, TaskEvents])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.attachedDatabase);

  // Templates ---------------------------------------------------------------

  SimpleSelectStatement<$TaskTemplatesTable, TemplateRow> _templatesQuery({
    required bool includeArchived,
  }) {
    final q = select(taskTemplates);
    if (!includeArchived) q.where((t) => t.archivedAt.isNull());
    q.orderBy([
      (t) => OrderingTerm.asc(t.sortOrder),
      (t) => OrderingTerm.asc(t.id),
    ]);
    return q;
  }

  Future<List<TemplateRow>> templates({required bool includeArchived}) =>
      _templatesQuery(includeArchived: includeArchived).get();

  Stream<List<TemplateRow>> watchTemplates({required bool includeArchived}) =>
      _templatesQuery(includeArchived: includeArchived).watch();

  Future<TemplateRow?> templateById(int id) =>
      (select(taskTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTemplate(TaskTemplatesCompanion row) =>
      into(taskTemplates).insert(row);

  Future<void> updateTemplate(TaskTemplatesCompanion row) => (update(
    taskTemplates,
  )..where((t) => t.id.equals(row.id.value))).write(row);

  Future<void> setSortOrder(int id, int order) =>
      (update(taskTemplates)..where((t) => t.id.equals(id))).write(
        TaskTemplatesCompanion(sortOrder: Value(order)),
      );

  // Daily tasks ---------------------------------------------------------------

  Future<List<DailyTaskRow>> dailyTasksOn(String date) =>
      (select(dailyTasks)..where((t) => t.date.equals(date))).get();

  /// Today's tasks joined with their template, in template order.
  Stream<List<(DailyTaskRow, TemplateRow)>> watchDailyTasksWithTemplate(
    String date,
  ) {
    final q =
        select(dailyTasks).join([
            innerJoin(
              taskTemplates,
              taskTemplates.id.equalsExp(dailyTasks.templateId),
            ),
          ])
          ..where(dailyTasks.date.equals(date))
          ..orderBy([
            OrderingTerm.asc(taskTemplates.sortOrder),
            OrderingTerm.asc(taskTemplates.id),
          ]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          (r.readTable(dailyTasks), r.readTable(taskTemplates)),
      ],
    );
  }

  Future<DailyTaskRow?> dailyTaskById(int id) =>
      (select(dailyTasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<DailyTaskRow?> dailyTaskFor(int templateId, String date) =>
      (select(dailyTasks)..where(
            (t) => t.templateId.equals(templateId) & t.date.equals(date),
          ))
          .getSingleOrNull();

  /// Inserts unless the (templateId, date) pair exists. Callers run this in
  /// a transaction; the unique key is the final guard against duplicates.
  Future<int?> insertDailyTaskIfAbsent(DailyTasksCompanion row) async {
    final existing = await dailyTaskFor(row.templateId.value, row.date.value);
    if (existing != null) return null;
    return into(dailyTasks).insert(row, mode: InsertMode.insertOrIgnore);
  }

  Future<void> updateDailyTask(DailyTasksCompanion row) =>
      (update(dailyTasks)..where((t) => t.id.equals(row.id.value))).write(row);

  Future<void> deleteDailyTask(int id) =>
      (delete(dailyTasks)..where((t) => t.id.equals(id))).go();

  Future<String?> latestTaskDate() async {
    final maxDate = dailyTasks.date.max();
    final row = await (selectOnly(
      dailyTasks,
    )..addColumns([maxDate])).getSingle();
    return row.read(maxDate);
  }

  Future<List<DailyTaskRow>> allDailyTasks() =>
      (select(dailyTasks)..orderBy([(t) => OrderingTerm.asc(t.date)])).get();

  Stream<List<DailyTaskRow>> watchAllDailyTasks() =>
      (select(dailyTasks)..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  // Events ---------------------------------------------------------------------

  Future<int> insertEvent(TaskEventsCompanion row) =>
      into(taskEvents).insert(row);

  Future<bool> hasDayComplete(String date) async {
    final count = taskEvents.id.count();
    final row =
        await (selectOnly(taskEvents)
              ..addColumns([count])
              ..where(
                taskEvents.date.equals(date) &
                    taskEvents.kind.equals('dayComplete'),
              ))
            .getSingle();
    return (row.read(count) ?? 0) > 0;
  }

  Future<int> eventCountForDailyTask(int dailyTaskId) async {
    final count = taskEvents.id.count();
    final row =
        await (selectOnly(taskEvents)
              ..addColumns([count])
              ..where(taskEvents.dailyTaskId.equals(dailyTaskId)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<TaskEventRow>> allEvents() =>
      (select(taskEvents)..orderBy([
            (t) => OrderingTerm.asc(t.occurredAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
          .get();
}
