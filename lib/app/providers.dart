import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repositories/drift_backup_repository.dart';
import '../data/repositories/drift_settings_repository.dart';
import '../data/repositories/drift_task_repository.dart';
import '../domain/hooks/progress_hook.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import '../domain/stats.dart';
import '../domain/task_service.dart';

/// Wall clock; overridden in tests.
final clockProvider = Provider<Clock>((ref) => DateTime.now);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(driftDatabase(name: 'dailyquest'));
  ref.onDispose(db.close);
  return db;
});

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => DriftTaskRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(ref.watch(databaseProvider)),
);

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => DriftBackupRepository(
    ref.watch(databaseProvider),
    ref.watch(settingsRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Extension point for the future game layer: add hooks to this list (e.g.
/// via a provider override in the game module). v1 registers a no-op hook.
final progressHooksProvider = Provider<List<ProgressHook>>(
  (ref) => const [NoopProgressHook()],
);

/// The single entry point for task state changes.
final taskServiceProvider = Provider<TaskService>(
  (ref) => TaskService(
    tasks: ref.watch(taskRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    hooks: ref.watch(progressHooksProvider),
    clock: ref.watch(clockProvider),
    onHookError: (error, stack) => FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'progress hooks',
      ),
    ),
  ),
);

final settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchSettings(),
);

final profileProvider = StreamProvider<Profile>(
  (ref) => ref.watch(settingsRepositoryProvider).watchProfile(),
);

/// Bumped whenever the logical day may have changed (app resume, timer at
/// the day cut-over, dayStartHour edit). Pages watching [todayDateProvider]
/// then regenerate and re-query.
final dayTickProvider = NotifierProvider<DayTick, int>(DayTick.new);

class DayTick extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

/// The current logical date; generating its tasks first (idempotent).
final todayDateProvider = FutureProvider<LocalDate>((ref) async {
  ref.watch(dayTickProvider);
  // Re-evaluate when dayStartHour changes.
  await ref.watch(settingsProvider.selectAsync((s) => s.dayStartHour));
  return ref.read(taskServiceProvider).ensureToday();
});

final todayTasksProvider = StreamProvider<List<TodayTask>>((ref) async* {
  final date = await ref.watch(todayDateProvider.future);
  yield* ref.watch(taskRepositoryProvider).watchTodayTasks(date);
});

final allDailyTasksProvider = StreamProvider<List<DailyTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchAllDailyTasks(),
);

final templatesProvider = StreamProvider<List<TaskTemplate>>(
  (ref) => ref.watch(taskRepositoryProvider).watchTemplates(),
);

final allTemplatesProvider = StreamProvider<List<TaskTemplate>>(
  (ref) =>
      ref.watch(taskRepositoryProvider).watchTemplates(includeArchived: true),
);

/// Summaries of every day with tasks.
final daySummariesProvider = Provider<AsyncValue<Map<LocalDate, DaySummary>>>(
  (ref) => ref.watch(allDailyTasksProvider).whenData(Stats.summarize),
);

final streakProvider = Provider<AsyncValue<StreakInfo>>((ref) {
  final days = ref.watch(daySummariesProvider);
  final today = ref.watch(todayDateProvider);
  if (days is AsyncData && today is AsyncData) {
    return AsyncData(Stats.streak(days.requireValue, today.requireValue));
  }
  return const AsyncLoading();
});
