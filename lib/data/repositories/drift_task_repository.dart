import '../../domain/models.dart';
import '../../domain/repositories.dart';
import '../database.dart';
import '../mappers.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db);

  final AppDatabase _db;

  @override
  Future<T> transaction<T>(Future<T> Function() action) =>
      _db.transaction(action);

  @override
  Future<List<TaskTemplate>> templates({bool includeArchived = false}) async =>
      (await _db.tasksDao.templates(includeArchived: includeArchived))
          .map((r) => r.toDomain())
          .toList();

  @override
  Stream<List<TaskTemplate>> watchTemplates({bool includeArchived = false}) =>
      _db.tasksDao
          .watchTemplates(includeArchived: includeArchived)
          .map((rows) => rows.map((r) => r.toDomain()).toList());

  @override
  Future<TaskTemplate?> templateById(int id) async =>
      (await _db.tasksDao.templateById(id))?.toDomain();

  @override
  Future<int> insertTemplate(TaskTemplate template) =>
      _db.tasksDao.insertTemplate(template.toCompanion());

  @override
  Future<void> updateTemplate(TaskTemplate template) =>
      _db.tasksDao.updateTemplate(template.toCompanion(withId: true));

  @override
  Future<void> updateSortOrders(Map<int, int> sortOrderById) =>
      _db.transaction(() async {
        for (final e in sortOrderById.entries) {
          await _db.tasksDao.setSortOrder(e.key, e.value);
        }
      });

  @override
  Future<List<DailyTask>> dailyTasksOn(LocalDate date) async =>
      (await _db.tasksDao.dailyTasksOn(date.toString()))
          .map((r) => r.toDomain())
          .toList();

  @override
  Stream<List<TodayTask>> watchTodayTasks(LocalDate date) => _db.tasksDao
      .watchDailyTasksWithTemplate(date.toString())
      .map(
        (rows) => [
          for (final (task, template) in rows)
            TodayTask(task: task.toDomain(), template: template.toDomain()),
        ],
      );

  @override
  Future<DailyTask?> dailyTaskById(int id) async =>
      (await _db.tasksDao.dailyTaskById(id))?.toDomain();

  @override
  Future<DailyTask?> dailyTaskFor(int templateId, LocalDate date) async =>
      (await _db.tasksDao.dailyTaskFor(
        templateId,
        date.toString(),
      ))?.toDomain();

  @override
  Future<int?> insertDailyTaskIfAbsent(DailyTask task) =>
      _db.tasksDao.insertDailyTaskIfAbsent(task.toCompanion());

  @override
  Future<void> updateDailyTask(DailyTask task) =>
      _db.tasksDao.updateDailyTask(task.toCompanion(withId: true));

  @override
  Future<void> deleteDailyTask(int id) => _db.tasksDao.deleteDailyTask(id);

  @override
  Future<LocalDate?> latestTaskDate() async {
    final raw = await _db.tasksDao.latestTaskDate();
    return raw == null ? null : LocalDate.parse(raw);
  }

  @override
  Future<List<DailyTask>> allDailyTasks() async =>
      (await _db.tasksDao.allDailyTasks()).map((r) => r.toDomain()).toList();

  @override
  Stream<List<DailyTask>> watchAllDailyTasks() => _db.tasksDao
      .watchAllDailyTasks()
      .map((rows) => rows.map((r) => r.toDomain()).toList());

  @override
  Future<int> insertEvent(TaskEvent event) =>
      _db.tasksDao.insertEvent(event.toCompanion());

  @override
  Future<bool> hasDayComplete(LocalDate date) =>
      _db.tasksDao.hasDayComplete(date.toString());

  @override
  Future<int> eventCountForDailyTask(int dailyTaskId) =>
      _db.tasksDao.eventCountForDailyTask(dailyTaskId);

  @override
  Future<List<TaskEvent>> allEvents() async =>
      (await _db.tasksDao.allEvents()).map((r) => r.toDomain()).toList();
}
