import 'package:dailyquest/data/database.dart';
import 'package:dailyquest/data/repositories/drift_backup_repository.dart';
import 'package:dailyquest/data/repositories/drift_settings_repository.dart';
import 'package:dailyquest/data/repositories/drift_task_repository.dart';
import 'package:dailyquest/domain/hooks/progress_hook.dart';
import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/task_service.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';

/// A controllable clock.
class FakeClock {
  FakeClock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration d) => now = now.add(d);
}

/// Records every hook call for assertions.
class RecordingHook extends ProgressHook {
  final progress = <TaskEvent>[];
  final completed = <TaskEvent>[];
  final days = <DateTime>[];

  @override
  void onProgress(TaskEvent e) => progress.add(e);

  @override
  void onTaskCompleted(TaskEvent e) => completed.add(e);

  @override
  void onDayCompleted(DateTime day) => days.add(day);
}

/// In-memory database + real repositories + service.
class TestEnv {
  TestEnv._(this.db, this.clock, this.hook)
    : tasks = DriftTaskRepository(db),
      settings = DriftSettingsRepository(db) {
    backup = DriftBackupRepository(db, settings, clock: clock.call);
    service = TaskService(
      tasks: tasks,
      settings: settings,
      hooks: [hook],
      clock: clock.call,
    );
  }

  factory TestEnv({DateTime? now}) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    return TestEnv._(
      AppDatabase(NativeDatabase.memory()),
      FakeClock(now ?? DateTime(2026, 10, 8, 9)),
      RecordingHook(),
    );
  }

  final AppDatabase db;
  final FakeClock clock;
  final RecordingHook hook;
  final DriftTaskRepository tasks;
  final DriftSettingsRepository settings;
  late final DriftBackupRepository backup;
  late final TaskService service;

  Future<void> dispose() => db.close();

  /// Creates a daily template and returns its id.
  Future<int> addTemplate({
    String name = '背单词',
    int target = 100,
    int step = 10,
    String unit = '个',
    TaskType type = TaskType.count,
    RepeatRule repeat = const RepeatRule.daily(),
  }) => service.createTemplate(
    TaskTemplate(
      name: name,
      icon: 'sym:book',
      colorIndex: 0,
      type: type,
      target: target,
      step: step,
      unit: unit,
      repeat: repeat,
      createdAt: clock.now,
    ),
  );

  Future<List<DailyTask>> tasksOn(LocalDate d) => tasks.dailyTasksOn(d);

  Future<DailyTask> taskFor(int templateId, LocalDate d) async =>
      (await tasks.dailyTaskFor(templateId, d))!;

  Future<List<TaskEvent>> events() => tasks.allEvents();
}
