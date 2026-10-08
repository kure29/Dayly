import '../../domain/backup.dart';
import '../../domain/repositories.dart';
import '../database.dart';
import '../mappers.dart';

class DriftBackupRepository implements BackupRepository {
  DriftBackupRepository(this._db, this._settings, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SettingsRepository _settings;
  final DateTime Function() _clock;

  @override
  Future<BackupData> exportAll() => _db.transaction(() async {
    return BackupData(
      exportedAt: _clock(),
      profile: await _settings.loadProfile(),
      settings: await _settings.loadSettings(),
      templates: (await _db.tasksDao.templates(includeArchived: true))
          .map((r) => r.toDomain())
          .toList(),
      dailyTasks: (await _db.tasksDao.allDailyTasks())
          .map((r) => r.toDomain())
          .toList(),
      events: (await _db.tasksDao.allEvents())
          .map((r) => r.toDomain())
          .toList(),
    );
  });

  @override
  Future<void> importAll(BackupData data) => _db.transaction(() async {
    await _wipe();
    await _settings.saveSettings(data.settings);
    await _db.settingsDao.setSeeded(true);
    await _settings.saveProfile(data.profile);
    await _db.batch((b) {
      b.insertAll(
        _db.taskTemplates,
        data.templates.map((t) => t.toCompanion(withId: true)),
      );
      b.insertAll(
        _db.dailyTasks,
        data.dailyTasks.map((t) => t.toCompanion(withId: true)),
      );
      b.insertAll(
        _db.taskEvents,
        data.events.map((e) => e.toCompanion(withId: true)),
      );
    });
  });

  @override
  Future<void> resetAll() => _db.transaction(_wipe);

  Future<void> _wipe() async {
    // Children first because of the daily_tasks → task_templates FK.
    await _db.delete(_db.taskEvents).go();
    await _db.delete(_db.dailyTasks).go();
    await _db.delete(_db.taskTemplates).go();
    await _db.delete(_db.profiles).go();
    await _db.delete(_db.settingsEntries).go();
  }
}
