import 'package:drift/drift.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';
import '../database.dart';
import '../mappers.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db, {this.defaultProfile = defaultProfileZh});

  static const defaultProfileZh = Profile(nickname: '同学', avatarChar: '我');

  final AppDatabase _db;

  /// Returned until the user (or seeding) saves a profile.
  final Profile defaultProfile;

  @override
  Future<AppSettings> loadSettings() async =>
      (await _db.settingsDao.settings())?.toDomain() ?? const AppSettings();

  @override
  Stream<AppSettings> watchSettings() => _db.settingsDao.watchSettings().map(
    (row) => row?.toDomain() ?? const AppSettings(),
  );

  @override
  Future<void> saveSettings(AppSettings settings) =>
      _db.settingsDao.upsertSettings(settings.toCompanion());

  @override
  Future<Profile> loadProfile() async {
    final row = await _db.settingsDao.profile();
    return row == null
        ? defaultProfile
        : Profile(nickname: row.nickname, avatarChar: row.avatarChar);
  }

  @override
  Stream<Profile> watchProfile() => _db.settingsDao.watchProfile().map(
    (row) => row == null
        ? defaultProfile
        : Profile(nickname: row.nickname, avatarChar: row.avatarChar),
  );

  @override
  Future<void> saveProfile(Profile profile) => _db.settingsDao.upsertProfile(
    ProfilesCompanion(
      id: const Value(1),
      nickname: Value(profile.nickname),
      avatarChar: Value(profile.avatarChar),
    ),
  );

  @override
  Future<bool> isSeeded() async =>
      (await _db.settingsDao.settings())?.seeded ?? false;

  @override
  Future<void> markSeeded() async {
    if (await _db.settingsDao.settings() == null) {
      await saveSettings(const AppSettings());
    }
    await _db.settingsDao.setSeeded(true);
  }
}
