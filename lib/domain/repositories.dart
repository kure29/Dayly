import 'backup.dart';
import 'models.dart';

/// Storage for templates, daily tasks and the event log.
///
/// The drift implementation lives in `lib/data`; a cloud-synced
/// implementation can replace it without touching the domain layer.
abstract interface class TaskRepository {
  /// Runs [action] atomically. Nested calls join the outer transaction.
  Future<T> transaction<T>(Future<T> Function() action);

  // Templates
  Future<List<TaskTemplate>> templates({bool includeArchived = false});
  Stream<List<TaskTemplate>> watchTemplates({bool includeArchived = false});
  Future<TaskTemplate?> templateById(int id);
  Future<int> insertTemplate(TaskTemplate template);
  Future<void> updateTemplate(TaskTemplate template);
  Future<void> updateSortOrders(Map<int, int> sortOrderById);

  // Daily tasks
  Future<List<DailyTask>> dailyTasksOn(LocalDate date);
  Stream<List<TodayTask>> watchTodayTasks(LocalDate date);
  Future<DailyTask?> dailyTaskById(int id);
  Future<DailyTask?> dailyTaskFor(int templateId, LocalDate date);

  /// Inserts unless a task for the same (template, date) exists; returns the
  /// new id or `null` if it already existed.
  Future<int?> insertDailyTaskIfAbsent(DailyTask task);
  Future<void> updateDailyTask(DailyTask task);
  Future<void> deleteDailyTask(int id);
  Future<LocalDate?> latestTaskDate();
  Future<List<DailyTask>> allDailyTasks();
  Stream<List<DailyTask>> watchAllDailyTasks();

  // Events
  Future<int> insertEvent(TaskEvent event);
  Future<bool> hasDayComplete(LocalDate date);
  Future<int> eventCountForDailyTask(int dailyTaskId);
  Future<List<TaskEvent>> allEvents();
}

abstract interface class SettingsRepository {
  Future<AppSettings> loadSettings();
  Stream<AppSettings> watchSettings();
  Future<void> saveSettings(AppSettings settings);

  Future<Profile> loadProfile();
  Stream<Profile> watchProfile();
  Future<void> saveProfile(Profile profile);

  /// Whether first-launch sample data was written.
  Future<bool> isSeeded();
  Future<void> markSeeded();
}

abstract interface class BackupRepository {
  Future<BackupData> exportAll();

  /// Replaces all data with [data] atomically.
  Future<void> importAll(BackupData data);

  /// Deletes everything and restores defaults.
  Future<void> resetAll();
}
