import 'dart:convert';
import 'dart:io';

import 'package:dailyquest/core/theme/scheme_definition.dart';
import 'package:dailyquest/core/theme/theme_registry.dart';

/// Loads the shipped schemes straight from `assets/themes` (no asset bundle
/// needed in pure unit tests).
ThemeRegistry loadRegistryFromDisk() {
  final dir = Directory('assets/themes');
  final files =
      dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  return ThemeRegistry(
    files.map(
      (f) => SchemeDefinition.fromJson(
        jsonDecode(f.readAsStringSync()) as Map<String, Object?>,
      ),
    ),
  );
}
