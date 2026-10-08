import 'dart:convert';

import 'models.dart';

/// Everything the user owns, in a JSON-serializable form.
class BackupData {
  const BackupData({
    required this.exportedAt,
    required this.profile,
    required this.settings,
    required this.templates,
    required this.dailyTasks,
    required this.events,
    this.formatVersion = currentFormatVersion,
  });

  static const int currentFormatVersion = 1;
  static const String appTag = 'dailyquest-backup';

  final int formatVersion;
  final DateTime exportedAt;
  final Profile profile;
  final AppSettings settings;
  final List<TaskTemplate> templates;
  final List<DailyTask> dailyTasks;
  final List<TaskEvent> events;

  Map<String, Object?> toJson() => {
    'app': appTag,
    'formatVersion': formatVersion,
    'exportedAt': exportedAt.toIso8601String(),
    'profile': profile.toJson(),
    'settings': settings.toJson(),
    'templates': templates.map((t) => t.toJson()).toList(),
    'dailyTasks': dailyTasks.map((t) => t.toJson()).toList(),
    'events': events.map((e) => e.toJson()).toList(),
  };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Parses and validates a backup. Throws [FormatException] on anything
  /// that isn't a compatible backup file.
  factory BackupData.decode(String source) {
    final Object? raw;
    try {
      raw = jsonDecode(source);
    } on FormatException {
      throw const FormatException('Not a JSON file');
    }
    if (raw is! Map<String, Object?> || raw['app'] != appTag) {
      throw const FormatException('Not a Daily Quest backup');
    }
    return BackupData.fromJson(raw);
  }

  factory BackupData.fromJson(Map<String, Object?> j) {
    final version = (j['formatVersion'] as num?)?.toInt() ?? 0;
    if (version < 1 || version > currentFormatVersion) {
      throw FormatException('Unsupported backup version $version');
    }
    List<Map<String, Object?>> list(String key) =>
        (j[key] as List<Object?>? ?? const []).cast<Map<String, Object?>>();
    try {
      final data = BackupData(
        formatVersion: version,
        exportedAt: DateTime.parse(j['exportedAt']! as String),
        profile: Profile.fromJson(j['profile']! as Map<String, Object?>),
        settings: AppSettings.fromJson(j['settings']! as Map<String, Object?>),
        templates: list('templates').map(TaskTemplate.fromJson).toList(),
        dailyTasks: list('dailyTasks').map(DailyTask.fromJson).toList(),
        events: list('events').map(TaskEvent.fromJson).toList(),
      );
      data._validate();
      return data;
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Corrupt backup: $e');
    }
  }

  void _validate() {
    final templateIds = templates.map((t) => t.id).toSet();
    if (templateIds.length != templates.length) {
      throw const FormatException('Duplicate template ids');
    }
    for (final t in dailyTasks) {
      if (!templateIds.contains(t.templateId)) {
        throw FormatException('Task ${t.id} references unknown template');
      }
    }
  }
}
