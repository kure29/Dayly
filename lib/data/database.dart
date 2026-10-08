import 'package:drift/drift.dart';

import 'daos/settings_dao.dart';
import 'daos/tasks_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [TaskTemplates, DailyTasks, TaskEvents, Profiles, SettingsEntries],
  daos: [TasksDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Bump on every schema change and add a step to [migration]. Snapshot
  /// the schema with `dart run drift_dev make-migrations` (see README).
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Apply each step in order so users can skip versions safely.
      for (var version = from + 1; version <= to; version++) {
        await _migrateTo(m, version);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _migrateTo(Migrator m, int version) async {
    switch (version) {
      // case 2:
      //   await m.addColumn(taskTemplates, taskTemplates.someNewColumn);
      default:
        throw StateError('No migration to schema version $version');
    }
  }
}
