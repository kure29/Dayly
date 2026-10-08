import 'local_date.dart';

export 'local_date.dart';

/// Returns the current time; injected so tests can control it.
typedef Clock = DateTime Function();

enum TaskType {
  /// Count up to a target (e.g. 100 words).
  count,

  /// Done / not done.
  once,

  /// Minutes.
  duration;

  static TaskType parse(String name) =>
      values.firstWhere((v) => v.name == name, orElse: () => TaskType.count);
}

enum EventKind {
  progress,
  complete,
  undo,
  dayComplete;

  static EventKind parse(String name) => values.byName(name);
}

enum EventSource {
  app,
  widget;

  static EventSource parse(String name) =>
      values.firstWhere((v) => v.name == name, orElse: () => EventSource.app);
}

enum RepeatKind { daily, weekdays, custom }

/// Light / dark preference stored in settings.
enum BrightnessMode {
  system,
  light,
  dark;

  static BrightnessMode parse(String? name) => BrightnessMode.values.firstWhere(
    (m) => m.name == name,
    orElse: () => BrightnessMode.system,
  );
}

/// Which weekdays a template is scheduled on.
class RepeatRule {
  const RepeatRule._(this.kind, this.weekdayMask);

  const RepeatRule.daily() : this._(RepeatKind.daily, allDays);

  const RepeatRule.weekdays() : this._(RepeatKind.weekdays, workDays);

  /// [weekdays] uses ISO numbering (Monday = 1 … Sunday = 7).
  factory RepeatRule.custom(Iterable<int> weekdays) {
    var mask = 0;
    for (final d in weekdays) {
      if (d < 1 || d > 7) throw ArgumentError.value(d, 'weekday');
      mask |= 1 << (d - 1);
    }
    return RepeatRule._(RepeatKind.custom, mask);
  }

  factory RepeatRule.fromStorage(String kind, int mask) =>
      switch (RepeatKind.values.byName(kind)) {
        RepeatKind.daily => const RepeatRule.daily(),
        RepeatKind.weekdays => const RepeatRule.weekdays(),
        RepeatKind.custom => RepeatRule._(RepeatKind.custom, mask & allDays),
      };

  static const int allDays = 0x7F;
  static const int workDays = 0x1F;

  final RepeatKind kind;

  /// Bit 0 = Monday … bit 6 = Sunday.
  final int weekdayMask;

  Set<int> get weekdays => {
    for (var d = 1; d <= 7; d++)
      if (weekdayMask & (1 << (d - 1)) != 0) d,
  };

  bool appliesOn(LocalDate date) =>
      weekdayMask & (1 << (date.weekday - 1)) != 0;

  bool get isEmpty => weekdayMask == 0;

  @override
  bool operator ==(Object other) =>
      other is RepeatRule &&
      other.kind == kind &&
      other.weekdayMask == weekdayMask;

  @override
  int get hashCode => Object.hash(kind, weekdayMask);
}

/// A user-defined recurring task.
class TaskTemplate {
  const TaskTemplate({
    this.id = 0,
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.type,
    required this.target,
    required this.step,
    required this.unit,
    this.repeat = const RepeatRule.daily(),
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
    this.archivedAt,
  });

  /// 0 for templates that haven't been inserted yet.
  final int id;
  final String name;

  /// A single character, or `sym:<key>` for a built-in icon.
  final String icon;
  final int colorIndex;
  final TaskType type;
  final int target;
  final int step;
  final String unit;
  final RepeatRule repeat;

  /// `false` while paused.
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;

  TaskTemplate copyWith({
    int? id,
    String? name,
    String? icon,
    int? colorIndex,
    TaskType? type,
    int? target,
    int? step,
    String? unit,
    RepeatRule? repeat,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? Function()? archivedAt,
  }) => TaskTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorIndex: colorIndex ?? this.colorIndex,
    type: type ?? this.type,
    target: target ?? this.target,
    step: step ?? this.step,
    unit: unit ?? this.unit,
    repeat: repeat ?? this.repeat,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt != null ? archivedAt() : this.archivedAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'colorIndex': colorIndex,
    'type': type.name,
    'target': target,
    'step': step,
    'unit': unit,
    'repeatKind': repeat.kind.name,
    'repeatDays': repeat.weekdayMask,
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': createdAt.toIso8601String(),
    'archivedAt': archivedAt?.toIso8601String(),
  };

  factory TaskTemplate.fromJson(Map<String, Object?> j) => TaskTemplate(
    id: (j['id']! as num).toInt(),
    name: j['name']! as String,
    icon: j['icon']! as String,
    colorIndex: (j['colorIndex']! as num).toInt(),
    type: TaskType.parse(j['type']! as String),
    target: (j['target']! as num).toInt(),
    step: (j['step']! as num).toInt(),
    unit: j['unit']! as String,
    repeat: RepeatRule.fromStorage(
      j['repeatKind']! as String,
      (j['repeatDays']! as num).toInt(),
    ),
    isActive: j['isActive']! as bool,
    sortOrder: (j['sortOrder']! as num).toInt(),
    createdAt: DateTime.parse(j['createdAt']! as String),
    archivedAt: j['archivedAt'] == null
        ? null
        : DateTime.parse(j['archivedAt']! as String),
  );
}

/// One day's instance of a template. Name/target/unit/step/type are a
/// snapshot taken at generation time so later template edits don't rewrite
/// history.
class DailyTask {
  const DailyTask({
    this.id = 0,
    required this.templateId,
    required this.date,
    this.progress = 0,
    this.completedAt,
    required this.name,
    required this.target,
    required this.unit,
    required this.step,
    required this.type,
  });

  final int id;
  final int templateId;
  final LocalDate date;
  final int progress;
  final DateTime? completedAt;
  final String name;
  final int target;
  final String unit;
  final int step;
  final TaskType type;

  bool get isCompleted => completedAt != null;

  /// 0–1.
  double get fraction => target <= 0 ? 0 : (progress / target).clamp(0, 1);

  DailyTask copyWith({
    int? id,
    int? progress,
    DateTime? Function()? completedAt,
    String? name,
    int? target,
    String? unit,
    int? step,
    TaskType? type,
  }) => DailyTask(
    id: id ?? this.id,
    templateId: templateId,
    date: date,
    progress: progress ?? this.progress,
    completedAt: completedAt != null ? completedAt() : this.completedAt,
    name: name ?? this.name,
    target: target ?? this.target,
    unit: unit ?? this.unit,
    step: step ?? this.step,
    type: type ?? this.type,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'templateId': templateId,
    'date': date.toString(),
    'progress': progress,
    'completedAt': completedAt?.toIso8601String(),
    'name': name,
    'target': target,
    'unit': unit,
    'step': step,
    'type': type.name,
  };

  factory DailyTask.fromJson(Map<String, Object?> j) => DailyTask(
    id: (j['id']! as num).toInt(),
    templateId: (j['templateId']! as num).toInt(),
    date: LocalDate.parse(j['date']! as String),
    progress: (j['progress']! as num).toInt(),
    completedAt: j['completedAt'] == null
        ? null
        : DateTime.parse(j['completedAt']! as String),
    name: j['name']! as String,
    target: (j['target']! as num).toInt(),
    unit: j['unit']! as String,
    step: (j['step']! as num).toInt(),
    type: TaskType.parse(j['type']! as String),
  );
}

/// Append-only log entry. Every state change goes through `TaskService`,
/// which writes one of these; replaying the log reproduces history.
class TaskEvent {
  const TaskEvent({
    this.id = 0,
    required this.dailyTaskId,
    required this.templateId,
    required this.date,
    required this.delta,
    required this.newProgress,
    required this.kind,
    required this.source,
    required this.occurredAt,
  });

  final int id;

  /// `null` for [EventKind.dayComplete].
  final int? dailyTaskId;

  /// `null` for [EventKind.dayComplete].
  final int? templateId;
  final LocalDate date;
  final int delta;
  final int newProgress;
  final EventKind kind;
  final EventSource source;
  final DateTime occurredAt;

  TaskEvent withId(int id) => TaskEvent(
    id: id,
    dailyTaskId: dailyTaskId,
    templateId: templateId,
    date: date,
    delta: delta,
    newProgress: newProgress,
    kind: kind,
    source: source,
    occurredAt: occurredAt,
  );

  TaskEvent withDailyTaskId(int dailyTaskId) => TaskEvent(
    id: id,
    dailyTaskId: dailyTaskId,
    templateId: templateId,
    date: date,
    delta: delta,
    newProgress: newProgress,
    kind: kind,
    source: source,
    occurredAt: occurredAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'dailyTaskId': dailyTaskId,
    'templateId': templateId,
    'date': date.toString(),
    'delta': delta,
    'newProgress': newProgress,
    'kind': kind.name,
    'source': source.name,
    'occurredAt': occurredAt.toIso8601String(),
  };

  factory TaskEvent.fromJson(Map<String, Object?> j) => TaskEvent(
    id: (j['id']! as num).toInt(),
    dailyTaskId: (j['dailyTaskId'] as num?)?.toInt(),
    templateId: (j['templateId'] as num?)?.toInt(),
    date: LocalDate.parse(j['date']! as String),
    delta: (j['delta']! as num).toInt(),
    newProgress: (j['newProgress']! as num).toInt(),
    kind: EventKind.parse(j['kind']! as String),
    source: EventSource.parse(j['source']! as String),
    occurredAt: DateTime.parse(j['occurredAt']! as String),
  );

  @override
  String toString() =>
      'TaskEvent(${kind.name} $date task=$dailyTaskId Δ$delta → $newProgress '
      '${source.name})';
}

class Profile {
  const Profile({required this.nickname, required this.avatarChar});

  final String nickname;
  final String avatarChar;

  Profile copyWith({String? nickname, String? avatarChar}) => Profile(
    nickname: nickname ?? this.nickname,
    avatarChar: avatarChar ?? this.avatarChar,
  );

  Map<String, Object?> toJson() => {
    'nickname': nickname,
    'avatarChar': avatarChar,
  };

  factory Profile.fromJson(Map<String, Object?> j) => Profile(
    nickname: j['nickname']! as String,
    avatarChar: j['avatarChar']! as String,
  );

  @override
  bool operator ==(Object other) =>
      other is Profile &&
      other.nickname == nickname &&
      other.avatarChar == avatarChar;

  @override
  int get hashCode => Object.hash(nickname, avatarChar);
}

class AppSettings {
  const AppSettings({
    this.schemeId = defaultSchemeId,
    this.customAccent,
    this.brightnessMode = BrightnessMode.system,
    this.dayStartHour = 4,
    this.reminderEnabled = false,
    this.reminderMinutes = 20 * 60,
  });

  static const String defaultSchemeId = 'classic_blue';

  final String schemeId;

  /// ARGB of the custom accent, if the user ever picked one.
  final int? customAccent;
  final BrightnessMode brightnessMode;

  /// Hour (0–23) at which a new logical day begins.
  final int dayStartHour;
  final bool reminderEnabled;

  /// Minutes after midnight for the daily reminder.
  final int reminderMinutes;

  AppSettings copyWith({
    String? schemeId,
    int? Function()? customAccent,
    BrightnessMode? brightnessMode,
    int? dayStartHour,
    bool? reminderEnabled,
    int? reminderMinutes,
  }) => AppSettings(
    schemeId: schemeId ?? this.schemeId,
    customAccent: customAccent != null ? customAccent() : this.customAccent,
    brightnessMode: brightnessMode ?? this.brightnessMode,
    dayStartHour: dayStartHour ?? this.dayStartHour,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
  );

  Map<String, Object?> toJson() => {
    'schemeId': schemeId,
    'customAccent': customAccent,
    'brightnessMode': brightnessMode.name,
    'dayStartHour': dayStartHour,
    'reminderEnabled': reminderEnabled,
    'reminderMinutes': reminderMinutes,
  };

  factory AppSettings.fromJson(Map<String, Object?> j) => AppSettings(
    schemeId: j['schemeId'] as String? ?? defaultSchemeId,
    customAccent: (j['customAccent'] as num?)?.toInt(),
    brightnessMode: BrightnessMode.parse(j['brightnessMode'] as String?),
    dayStartHour: (j['dayStartHour'] as num?)?.toInt() ?? 4,
    reminderEnabled: j['reminderEnabled'] as bool? ?? false,
    reminderMinutes: (j['reminderMinutes'] as num?)?.toInt() ?? 20 * 60,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.schemeId == schemeId &&
      other.customAccent == customAccent &&
      other.brightnessMode == brightnessMode &&
      other.dayStartHour == dayStartHour &&
      other.reminderEnabled == reminderEnabled &&
      other.reminderMinutes == reminderMinutes;

  @override
  int get hashCode => Object.hash(
    schemeId,
    customAccent,
    brightnessMode,
    dayStartHour,
    reminderEnabled,
    reminderMinutes,
  );
}

/// A daily task joined with the live display attributes of its template.
class TodayTask {
  const TodayTask({required this.task, required this.template});

  final DailyTask task;
  final TaskTemplate template;

  String get icon => template.icon;
  int get colorIndex => template.colorIndex;
}
