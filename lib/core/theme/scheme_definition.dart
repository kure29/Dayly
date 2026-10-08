import 'dart:ui';

import 'color_utils.dart';

/// Number of colors in every scheme's task palette.
const int kTaskPaletteSize = 8;

/// Colors of one scheme for one brightness.
class SchemeColors {
  const SchemeColors({
    required this.accent,
    required this.ring,
    required this.success,
    required this.tasks,
  }) : assert(tasks.length == kTaskPaletteSize);

  final Color accent;
  final Color ring;
  final Color success;
  final List<Color> tasks;

  factory SchemeColors.fromJson(Map<String, Object?> json) {
    final tasks = (json['tasks']! as List<Object?>)
        .map((e) => ColorUtils.parseHex(e! as String))
        .toList(growable: false);
    if (tasks.length != kTaskPaletteSize) {
      throw FormatException(
        'A scheme needs exactly $kTaskPaletteSize task colors, got ${tasks.length}',
      );
    }
    return SchemeColors(
      accent: ColorUtils.parseHex(json['accent']! as String),
      ring: ColorUtils.parseHex(json['ring']! as String),
      success: ColorUtils.parseHex(json['success']! as String),
      tasks: tasks,
    );
  }

  Map<String, Object?> toJson() => {
    'accent': ColorUtils.toHex(accent),
    'ring': ColorUtils.toHex(ring),
    'success': ColorUtils.toHex(success),
    'tasks': tasks.map(ColorUtils.toHex).toList(),
  };
}

/// A color scheme as stored in `assets/themes/*.json` (or delivered by remote
/// config later). Pure data — no Flutter widgets involved.
class SchemeDefinition {
  const SchemeDefinition({
    required this.id,
    required this.names,
    required this.light,
    required this.dark,
    this.order = 1000,
    this.schemaVersion = currentSchemaVersion,
  });

  static const int currentSchemaVersion = 1;

  final String id;

  /// Localized display names keyed by language code (`zh`, `en`, …).
  final Map<String, String> names;
  final SchemeColors light;
  final SchemeColors dark;

  /// Position in the picker; lower comes first.
  final int order;
  final int schemaVersion;

  SchemeColors colorsFor(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  String displayName(String languageCode) =>
      names[languageCode] ?? names['en'] ?? names.values.first;

  factory SchemeDefinition.fromJson(Map<String, Object?> json) {
    final version = (json['schemaVersion'] as num?)?.toInt() ?? 1;
    if (version > currentSchemaVersion) {
      throw FormatException('Unsupported scheme schemaVersion $version');
    }
    return SchemeDefinition(
      id: json['id']! as String,
      names: (json['name']! as Map<String, Object?>).map(
        (k, v) => MapEntry(k, v! as String),
      ),
      light: SchemeColors.fromJson(json['light']! as Map<String, Object?>),
      dark: SchemeColors.fromJson(json['dark']! as Map<String, Object?>),
      order: (json['order'] as num?)?.toInt() ?? 1000,
      schemaVersion: version,
    );
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'id': id,
    'order': order,
    'name': names,
    'light': light.toJson(),
    'dark': dark.toJson(),
  };
}
