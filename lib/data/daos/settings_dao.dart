import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'settings_dao.g.dart';

/// Access to the single-row settings and profile tables.
@DriftAccessor(tables: [SettingsEntries, Profiles])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.attachedDatabase);

  Future<SettingsRow?> settings() => select(settingsEntries).getSingleOrNull();

  Stream<SettingsRow?> watchSettings() =>
      select(settingsEntries).watchSingleOrNull();

  Future<void> upsertSettings(SettingsEntriesCompanion row) =>
      into(settingsEntries).insert(
        row,
        onConflict: DoUpdate((_) => row.copyWith(seeded: const Value.absent())),
      );

  Future<void> setSeeded(bool seeded) =>
      (update(settingsEntries)..where((t) => t.id.equals(1))).write(
        SettingsEntriesCompanion(seeded: Value(seeded)),
      );

  Future<ProfileRow?> profile() => select(profiles).getSingleOrNull();

  Stream<ProfileRow?> watchProfile() => select(profiles).watchSingleOrNull();

  Future<void> upsertProfile(ProfilesCompanion row) =>
      into(profiles).insertOnConflictUpdate(row);
}
