import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/features/today/today_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/seed.dart';
import '../helpers/test_env.dart';

void main() {
  final oct8 = LocalDate(2026, 10, 8);

  Future<TestEnv> seeded(WidgetTester tester) async {
    final env = TestEnv(now: DateTime(2026, 10, 8, 9));
    await tester.runAsync(() => seedSample(env));
    return env;
  }

  for (final brightness in Brightness.values) {
    testWidgets('today page renders sample data (${brightness.name})', (
      tester,
    ) async {
      final env = await seeded(tester);
      await pumpScreen(tester, env, const TodayPage(), brightness: brightness);
      await tester.pumpAndSettle();

      expect(find.text('今日'), findsOneWidget);
      expect(find.text('早上好，同学'), findsOneWidget);
      expect(find.text('10月8日星期四'), findsOneWidget);
      expect(find.text('已完成 0/4'), findsOneWidget);
      expect(find.text('背单词'), findsOneWidget);
      expect(find.text('0 / 100 个'), findsOneWidget);
      expect(find.text('数学练习题'), findsOneWidget);
      expect(find.text('0 / 1 套'), findsOneWidget);
      expect(find.text('0 / 30 分钟'), findsOneWidget);
      expect(find.text('0 / 20 分钟'), findsOneWidget);
      expect(find.text('+10'), findsNWidgets(3));
      expect(find.text('完成'), findsOneWidget);
      expect(find.text('添加任务'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmountAndClose(tester, env);
    });
  }

  testWidgets('check-in flow updates progress, events and day completion', (
    tester,
  ) async {
    final env = await seeded(tester);
    await pumpScreen(tester, env, const TodayPage());
    await tester.pumpAndSettle();

    final tasks = (await tester.runAsync(() => env.tasksOn(oct8)))!;
    final byName = {for (final t in tasks) t.name: t};

    // +10 on 背单词.
    await tester.tap(find.byKey(ValueKey('checkin-${byName['背单词']!.id}')));
    await tester.pumpAndSettle();
    expect(find.text('10 / 100 个'), findsOneWidget);

    // "完成" on the single-set task completes it.
    await tester.tap(find.byKey(ValueKey('checkin-${byName['数学练习题']!.id}')));
    await tester.pumpAndSettle();
    expect(find.text('1 / 1 套'), findsOneWidget);
    expect(find.text('已完成 1/4'), findsOneWidget);
    expect(find.text('「数学练习题」已完成'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));

    // Finish everything else.
    for (final name in ['背单词', '阅读', '运动']) {
      final task = byName[name]!;
      while (find.byKey(ValueKey('checkin-${task.id}')).evaluate().isNotEmpty) {
        await tester.tap(find.byKey(ValueKey('checkin-${task.id}')));
        await tester.pumpAndSettle();
      }
    }
    expect(find.text('已完成 4/4'), findsOneWidget);
    expect(find.text('今日任务全部完成'), findsOneWidget);
    expect(find.text('100 / 100 个'), findsOneWidget);

    final events = (await tester.runAsync(env.events))!;
    expect(events.where((e) => e.kind == EventKind.dayComplete), hasLength(1));
    expect(events.where((e) => e.kind == EventKind.complete), hasLength(4));
    expect(events.every((e) => e.source == EventSource.app), isTrue);

    await tester.pump(const Duration(seconds: 3));
    await unmountAndClose(tester, env);
  });

  testWidgets('long-press sets an exact value', (tester) async {
    final env = await seeded(tester);
    await pumpScreen(tester, env, const TodayPage());
    await tester.pumpAndSettle();

    await tester.longPress(find.text('背单词'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('progress-input')), '40');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(find.text('40 / 100 个'), findsOneWidget);

    // Out of range values are rejected.
    await tester.longPress(find.text('背单词'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('progress-input')), '400');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(find.text('0 – 100'), findsWidgets);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('40 / 100 个'), findsOneWidget);

    await unmountAndClose(tester, env);
  });
}
