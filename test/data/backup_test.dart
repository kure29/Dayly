import 'package:dailyquest/domain/backup.dart';
import 'package:dailyquest/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_env.dart';

void main() {
  test('JSON backup round-trips all data', () async {
    final source = TestEnv(now: DateTime(2026, 10, 6, 9));
    final target = TestEnv(now: DateTime(2026, 10, 8, 9));
    addTearDown(source.dispose);
    addTearDown(target.dispose);

    await source.settings.saveSettings(
      const AppSettings(
        schemeId: 'custom',
        customAccent: 0xFF8E44AD,
        brightnessMode: BrightnessMode.dark,
        dayStartHour: 5,
        reminderEnabled: true,
        reminderMinutes: 21 * 60 + 30,
      ),
    );
    await source.settings.saveProfile(
      const Profile(nickname: '小明', avatarChar: '明'),
    );
    final a = await source.addTemplate(name: '背单词');
    final b = await source.addTemplate(
      name: '阅读',
      target: 30,
      unit: '分钟',
      type: TaskType.duration,
      repeat: RepeatRule.custom([1, 3, 5]),
    );
    await source.service.advance(
      (await source.taskFor(a, LocalDate(2026, 10, 6))).id,
    );
    source.clock.now = DateTime(2026, 10, 7, 23);
    await source.service.ensureToday();
    await source.service.setProgress(
      (await source.taskFor(a, LocalDate(2026, 10, 7))).id,
      100,
    );
    await source.service.archiveTemplate(b);

    final exported = await source.backup.exportAll();
    final json = exported.encode();
    final decoded = BackupData.decode(json);
    await target.service.ensureToday(); // target had its own state
    await target.backup.importAll(decoded);
    final reexported = await target.backup.exportAll();

    Map<String, Object?> strip(BackupData d) =>
        d.toJson()..remove('exportedAt');
    expect(strip(reexported), strip(exported));
    expect(reexported.events, isNotEmpty);
    expect(reexported.templates.where((t) => t.isArchived), hasLength(1));
    expect(await target.settings.isSeeded(), isTrue);

    // The imported database is fully usable: ids continue after import.
    final newId = await target.addTemplate(name: '新任务');
    expect(newId, greaterThan(b));
  });

  test('rejects files that are not backups', () {
    expect(() => BackupData.decode('{}'), throwsFormatException);
    expect(() => BackupData.decode('nope'), throwsFormatException);
    expect(
      () => BackupData.decode('{"app":"dailyquest-backup","formatVersion":99}'),
      throwsFormatException,
    );
  });

  test('reset wipes everything', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    await env.addTemplate();
    await env.backup.resetAll();
    expect(await env.tasks.templates(includeArchived: true), isEmpty);
    expect(await env.tasks.allDailyTasks(), isEmpty);
    expect(await env.settings.isSeeded(), isFalse);
  });
}
