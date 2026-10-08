import 'dart:ui';

import 'package:dailyquest/core/l10n/l10n.dart';
import 'package:dailyquest/features/task_editor/builtin_templates.dart';

import 'test_env.dart';

/// Writes the same first-launch sample data as the app (zh).
Future<void> seedSample(TestEnv env) async {
  final l10n = lookupAppLocalizations(const Locale('zh'));
  await env.service.seedIfNeeded(buildSeedContent(l10n, env.clock.now));
}
