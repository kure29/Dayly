import 'package:dailyquest/core/theme/scheme_definition.dart';
import 'package:dailyquest/core/theme/theme_registry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/schemes.dart';

void main() {
  final registry = loadRegistryFromDisk();

  test('unknown ids fall back to the default scheme', () {
    expect(
      registry.resolve('does-not-exist').id,
      ThemeRegistry.defaultSchemeId,
    );
    expect(registry.resolve(null).id, ThemeRegistry.defaultSchemeId);
  });

  test('schemes round-trip through JSON (remote-config ready)', () {
    final json = registry.schemes.map((s) => s.toJson()).toList();
    final copy = ThemeRegistry.fromJsonList(json);
    for (final s in registry.schemes) {
      expect(copy.resolve(s.id).toJson(), s.toJson());
    }
  });

  test('merge adds remote schemes without code changes', () {
    final remote = SchemeDefinition.fromJson({
      ...registry.fallback.toJson(),
      'id': 'remote_teal',
      'order': 50,
      'name': {'zh': '远程青', 'en': 'Remote Teal'},
    });
    final merged = registry.merge([remote]);
    expect(merged.contains('remote_teal'), isTrue);
    expect(merged.schemes.last.id, 'remote_teal');
    expect(remote.displayName('zh'), '远程青');
  });

  test('rejects malformed palettes and future schema versions', () {
    final json = registry.fallback.toJson();
    final light = Map<String, Object?>.from(json['light']! as Map);
    light['tasks'] = ['#FFFFFF'];
    expect(
      () => SchemeDefinition.fromJson({...json, 'light': light}),
      throwsFormatException,
    );
    expect(
      () => SchemeDefinition.fromJson({...json, 'schemaVersion': 99}),
      throwsFormatException,
    );
  });
}
