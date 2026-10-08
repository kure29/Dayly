import '../../core/l10n/l10n.dart';
import '../../domain/models.dart';
import '../../domain/task_service.dart';

/// A one-tap starting point in the task editor.
class BuiltinTemplate {
  const BuiltinTemplate({
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.type,
    required this.target,
    required this.step,
    required this.unit,
  });

  final String name;
  final String icon;
  final int colorIndex;
  final TaskType type;
  final int target;
  final int step;
  final String unit;

  TaskTemplate toTemplate(DateTime now) => TaskTemplate(
    name: name,
    icon: icon,
    colorIndex: colorIndex,
    type: type,
    target: target,
    step: step,
    unit: unit,
    createdAt: now,
  );
}

/// 背单词、练习题、阅读、运动、听力.
List<BuiltinTemplate> builtinTemplates(AppLocalizations l10n) => [
  BuiltinTemplate(
    name: l10n.tplVocabulary,
    icon: 'sym:book',
    colorIndex: 0,
    type: TaskType.count,
    target: 100,
    step: 10,
    unit: l10n.unitCount,
  ),
  BuiltinTemplate(
    name: l10n.tplExercises,
    icon: 'sym:pencil',
    colorIndex: 1,
    type: TaskType.count,
    target: 1,
    step: 1,
    unit: l10n.unitSets,
  ),
  BuiltinTemplate(
    name: l10n.tplReading,
    icon: 'sym:doc',
    colorIndex: 2,
    type: TaskType.duration,
    target: 30,
    step: 10,
    unit: l10n.unitMinutes,
  ),
  BuiltinTemplate(
    name: l10n.tplWorkout,
    icon: 'sym:run',
    colorIndex: 3,
    type: TaskType.duration,
    target: 20,
    step: 10,
    unit: l10n.unitMinutes,
  ),
  BuiltinTemplate(
    name: l10n.tplListening,
    icon: 'sym:headphones',
    colorIndex: 4,
    type: TaskType.duration,
    target: 20,
    step: 5,
    unit: l10n.unitMinutes,
  ),
];

/// First-launch sample data: 背单词 0/100 个、数学练习题 0/1 套、
/// 阅读 0/30 分钟、运动 0/20 分钟.
SeedContent buildSeedContent(AppLocalizations l10n, DateTime now) {
  final b = builtinTemplates(l10n);
  return SeedContent(
    profile: Profile(
      nickname: l10n.defaultNickname,
      avatarChar: l10n.defaultNickname.characters.first,
    ),
    templates: [
      b[0].toTemplate(now),
      b[1].toTemplate(now).copyWith(name: l10n.seedMath),
      b[2].toTemplate(now),
      b[3].toTemplate(now),
    ],
  );
}

extension on String {
  Iterable<String> get characters => runes.map(String.fromCharCode);
}
