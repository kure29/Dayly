import 'dart:convert';

import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/widget_events.dart';
import 'package:dailyquest/widgets_bridge/widget_snapshot.dart';
import 'package:dailyquest/widgets_bridge/widget_store.dart';
import 'package:dailyquest/widgets_bridge/widget_sync.dart';
import 'package:dailyquest/widgets_bridge/widget_tap.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/schemes.dart';
import '../helpers/test_env.dart';

class FakeWidgetStore implements WidgetStore {
  final data = <String, String?>{};
  int refreshes = 0;

  /// Runs once before the next read of [key] (to simulate a concurrent tap).
  void Function()? beforeNextPendingRead;

  @override
  Future<String?> read(String key) async {
    if (key == WidgetKeys.pending && beforeNextPendingRead != null) {
      final hook = beforeNextPendingRead!;
      beforeNextPendingRead = null;
      hook();
    }
    return data[key];
  }

  @override
  Future<void> write(String key, String? value) async => data[key] = value;

  @override
  Future<void> refresh() async => refreshes++;
}

void main() {
  final registry = loadRegistryFromDisk();
  final oct8 = LocalDate(2026, 10, 8);
  late TestEnv env;
  late FakeWidgetStore store;
  late WidgetSync sync;

  setUp(() {
    env = TestEnv(now: DateTime(2026, 10, 8, 9));
    store = FakeWidgetStore();
    sync = WidgetSync(store, env.service);
  });
  tearDown(() => env.dispose());

  Future<Map<String, Object?>> snapshot() async {
    final date = await env.service.ensureToday();
    final tasks = await env.tasks.watchTodayTasks(date).first;
    return WidgetSnapshot.build(
      date: date,
      tasks: tasks,
      streak: 2,
      scheme: registry.fallback,
      mode: BrightnessMode.system,
      title: '今日任务',
      emptyText: '今天没有安排任务',
      staleText: '打开 App 开始新的一天',
      dayStartHour: 4,
      generatedAt: env.clock.now,
    );
  }

  /// Simulates a tap on the widget "+" for [taskId].
  void tap(int taskId, DateTime at) {
    final r = WidgetTap.apply(
      snapshotJson: store.data[WidgetKeys.snapshot],
      queueJson: store.data[WidgetKeys.pending],
      dailyTaskId: taskId,
      date: oct8.toString(),
      now: at,
    );
    store.data[WidgetKeys.pending] = r.queue;
    store.data[WidgetKeys.snapshot] = r.snapshot;
  }

  test('snapshot contains progress, colors for both modes and tasks', () async {
    final id = await env.addTemplate(name: '背单词');
    await env.service.advance((await env.taskFor(id, oct8)).id);
    final s = await snapshot();
    expect(s['v'], WidgetSnapshot.version);
    expect((s['done'], s['total'], s['streak']), (0, 1, 2));
    expect(s['nextDayAt'], '2026-10-09T04:00:00.000');
    final colors = s['colors']! as Map<String, Object?>;
    expect(colors.keys, containsAll(['light', 'dark']));
    final task = (s['tasks']! as List<Object?>).single! as Map<String, Object?>;
    expect(task['name'], '背单词');
    expect((task['progress'], task['target'], task['step']), (10, 100, 10));
    expect(task['glyph'], '📖');
    expect(task['sf'], 'book.fill');
    // Round-trips through JSON (what the native side receives).
    expect(jsonDecode(WidgetSnapshot.encode(s)), isA<Map<String, Object?>>());
  });

  test('tap updates the snapshot optimistically and queues an event', () async {
    final id = await env.addTemplate(target: 20, step: 10);
    final taskId = (await env.taskFor(id, oct8)).id;
    await sync.push(await snapshot());
    expect(store.refreshes, 1);

    tap(taskId, DateTime(2026, 10, 8, 10));
    tap(taskId, DateTime(2026, 10, 8, 11));
    tap(taskId, DateTime(2026, 10, 8, 12)); // already complete → ignored

    final s = jsonDecode(store.data[WidgetKeys.snapshot]!) as Map;
    final task = (s['tasks'] as List).single as Map;
    expect((task['progress'], task['done'], s['done']), (20, true, 1));
    expect(
      PendingWidgetEvent.decodeQueue(store.data[WidgetKeys.pending]),
      hasLength(2),
    );
  });

  test('merge writes widget events and clears only consumed entries', () async {
    final a = await env.addTemplate(name: 'a', target: 30, step: 10);
    final b = await env.addTemplate(name: 'b', target: 1, step: 1);
    final ta = (await env.taskFor(a, oct8)).id;
    final tb = (await env.taskFor(b, oct8)).id;
    await sync.push(await snapshot());

    tap(ta, DateTime(2026, 10, 8, 10));
    tap(ta, DateTime(2026, 10, 8, 10, 5));
    // A tap lands while the app is merging: it must survive for next time.
    store.beforeNextPendingRead = () {
      store.beforeNextPendingRead = () => tap(tb, DateTime(2026, 10, 8, 10, 6));
    };

    expect(await sync.mergePending(), 2);
    expect((await env.taskFor(a, oct8)).progress, 20);
    final left = PendingWidgetEvent.decodeQueue(store.data[WidgetKeys.pending]);
    expect(left.map((e) => e.dailyTaskId), [tb]);

    expect(await sync.mergePending(), 1);
    expect((await env.taskFor(b, oct8)).isCompleted, isTrue);
    expect(
      PendingWidgetEvent.decodeQueue(store.data[WidgetKeys.pending]),
      isEmpty,
    );

    final events = await env.events();
    final taskEvents = events.where((e) => e.kind != EventKind.dayComplete);
    expect(taskEvents.every((e) => e.source == EventSource.widget), isTrue);
    expect(taskEvents.map((e) => e.occurredAt), [
      DateTime(2026, 10, 8, 10),
      DateTime(2026, 10, 8, 10, 5),
      DateTime(2026, 10, 8, 10, 6),
    ]);
    expect(await sync.mergePending(), 0);
  });

  test('check-in URIs round-trip', () {
    final uri = WidgetTap.checkInUri(42, '2026-10-08');
    expect(uri.toString(), 'dailyquest://checkin?task=42&date=2026-10-08');
    expect(WidgetTap.parse(uri), (42, '2026-10-08'));
    expect(WidgetTap.parse(Uri.parse('dailyquest://open')), isNull);
    expect(WidgetTap.parse(null), isNull);
  });
}
