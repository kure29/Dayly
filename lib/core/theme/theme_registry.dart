import 'dart:convert';

import 'package:flutter/services.dart';

import 'scheme_definition.dart';

/// Holds every available color scheme.
///
/// Built-in schemes are discovered from the asset manifest: every JSON file
/// under `assets/themes/` becomes a scheme, so adding a scheme means adding a
/// file. [ThemeRegistry.fromJsonList] accepts the same JSON shape so schemes
/// can later come from remote config.
class ThemeRegistry {
  ThemeRegistry(Iterable<SchemeDefinition> schemes)
    : _schemes = {for (final s in schemes) s.id: s} {
    if (_schemes.isEmpty) {
      throw StateError('ThemeRegistry needs at least one scheme');
    }
  }

  static const String assetDirectory = 'assets/themes/';
  static const String defaultSchemeId = 'classic_blue';

  final Map<String, SchemeDefinition> _schemes;

  /// Schemes sorted for display.
  List<SchemeDefinition> get schemes => _schemes.values.toList()
    ..sort((a, b) {
      final byOrder = a.order.compareTo(b.order);
      return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
    });

  SchemeDefinition get fallback => _schemes[defaultSchemeId] ?? schemes.first;

  /// Looks up [id], falling back to the default scheme for unknown ids
  /// (e.g. a scheme that was removed after a user picked it).
  SchemeDefinition resolve(String? id) => _schemes[id] ?? fallback;

  bool contains(String id) => _schemes.containsKey(id);

  /// Returns a registry with [extra] schemes added or replacing existing ids.
  ThemeRegistry merge(Iterable<SchemeDefinition> extra) =>
      ThemeRegistry([..._schemes.values, ...extra]);

  factory ThemeRegistry.fromJsonList(List<Object?> json) => ThemeRegistry(
    json.map((e) => SchemeDefinition.fromJson(e! as Map<String, Object?>)),
  );

  /// Loads all schemes shipped in [assetDirectory].
  static Future<ThemeRegistry> loadFromAssets([AssetBundle? bundle]) async {
    final assets = bundle ?? rootBundle;
    final manifest = await AssetManifest.loadFromAssetBundle(assets);
    final paths =
        manifest
            .listAssets()
            .where((p) => p.startsWith(assetDirectory) && p.endsWith('.json'))
            .toList()
          ..sort();
    final schemes = <SchemeDefinition>[];
    for (final path in paths) {
      final raw = await assets.loadString(path);
      schemes.add(
        SchemeDefinition.fromJson(jsonDecode(raw) as Map<String, Object?>),
      );
    }
    return ThemeRegistry(schemes);
  }
}
