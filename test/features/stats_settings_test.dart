import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/features/settings/manage_tasks_page.dart';
import 'package:dailyquest/features/settings/me_page.dart';
import 'package:dailyquest/features/stats/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/seed.dart';
import '../helpers/test_env.dart';

void main() {
  /// Five fully completed days (10-03 … 10-07) of a 500-word task.
  Future<TestEnv> withHistory(WidgetTester tester) async {
    final env = TestEnv(now: DateTime(2026, 10, 3, 9));
    await tester.runAsync(() async {
      final id = await env.addTemplate(name: '背单词', target: 500, step: 50);
      for (var d = 3; d <= 7; d++) {
        env.clock.now = DateTime(2026, 10, d, 21);
        await env.service.ensureToday();
        final t = await env.taskFor(id, LocalDate(2026, 10, d));
        await env.service.setProgress(t.id, 500);
      }
      env.clock.now = DateTime(2026, 10, 8, 9);
      await env.service.ensureToday();
    });
    return env;
  }

  for (final brightness in Brightness.values) {
    testWidgets('stats page shows rings, heatmap, streaks and totals '
        '(${brightness.name})', (tester) async {
      final env = await withHistory(tester);
      await pumpScreen(tester, env, const StatsPage(), brightness: brightness);
      await tester.pumpAndSettle();

      expect(find.text('本周'), findsOneWidget);
      expect(find.text('最近 12 周'), findsOneWidget);
      expect(find.text('当前连续'), findsOneWidget);
      expect(find.text('5 天'), findsNWidgets(2)); // current & longest
      expect(find.text('累计 2,500 个'), findsOneWidget);
      expect(find.text('完成率 83%'), findsOneWidget); // 5 of 6 days
      expect(tester.takeException(), isNull);
      await unmountAndClose(tester, env);
    });
  }

  testWidgets('me page renders all settings groups', (tester) async {
    final env = TestEnv();
    await tester.runAsync(() => seedSample(env));
    await pumpScreen(tester, env, const MePage());
    await tester.pumpAndSettle();
    for (final label in ['个人', '昵称', '外观', '经典蓝', '跟随系统']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    await tester.scrollUntilVisible(
      find.text('重置所有数据'),
      200,
      scrollable: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    for (final label in ['管理任务', '一天开始时间', '提醒通知', '导出 JSON 备份']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('04:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await unmountAndClose(tester, env);
  });

  testWidgets('selecting a scheme and dark mode persists settings', (
    tester,
  ) async {
    final env = TestEnv();
    await pumpScreen(tester, env, const MePage());
    await tester.pumpAndSettle();
    await tester.tap(find.text('靛紫'));
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    final s = (await tester.runAsync(env.settings.loadSettings))!;
    expect(s.schemeId, 'indigo');
    expect(s.brightnessMode, BrightnessMode.dark);
    await unmountAndClose(tester, env);
  });

  testWidgets('manage tasks pauses a template', (tester) async {
    final env = TestEnv();
    await tester.runAsync(() => seedSample(env));
    await pumpScreen(tester, env, const ManageTasksPage());
    await tester.pumpAndSettle();
    expect(find.text('背单词'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    final t = (await tester.runAsync(env.tasks.templates))!.first;
    expect(t.isActive, isFalse);
    expect(find.textContaining('已暂停'), findsOneWidget);
    await unmountAndClose(tester, env);
  });
}
