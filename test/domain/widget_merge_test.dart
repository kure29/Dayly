import 'package:dailyquest/domain/models.dart';
import 'package:dailyquest/domain/widget_events.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_env.dart';

void main() {
  late TestEnv env;
  final oct8 = LocalDate(2026, 10, 8);

  setUp(() => env = TestEnv(now: DateTime(2026, 10, 8, 21)));
  tearDown(() => env.dispose());

  PendingWidgetEvent ev(String id, int taskId, DateTime at, [String? date]) =>
      PendingWidgetEvent(
        id: id,
        dailyTaskId: taskId,
        date: date ?? oct8.toString(),
        occurredAt: at,
      );

  test('queued widget check-ins become source=widget events', () async {
    final id = await env.addTemplate(target: 30, step: 10);
    final task = await env.taskFor(id, oct8);
    final consumed = await env.service.applyWidgetEvents([
      ev('b', task.id, DateTime(2026, 10, 8, 12)),
      ev('a', task.id, DateTime(2026, 10, 8, 11)),
    ]);
    expect(consumed, {'a', 'b'});
    expect((await env.taskFor(id, oct8)).progress, 20);
    final events = await env.events();
    expect(events, hasLength(2));
    expect(events.every((e) => e.source == EventSource.widget), isTrue);
    // Applied in the order they happened on the widget, with their times.
    expect(events.map((e) => e.occurredAt), [
      DateTime(2026, 10, 8, 11),
      DateTime(2026, 10, 8, 12),
    ]);
  });

  test('completing via widget writes complete and dayComplete', () async {
    final id = await env.addTemplate(target: 1, step: 1);
    final task = await env.taskFor(id, oct8);
    await env.service.applyWidgetEvents([
      ev('x', task.id, DateTime(2026, 10, 8, 20)),
      ev('y', task.id, DateTime(2026, 10, 8, 20, 1)), // extra tap: no-op
    ]);
    final kinds = (await env.events()).map((e) => e.kind).toList();
    expect(kinds, [EventKind.complete, EventKind.dayComplete]);
    expect(env.hook.days, hasLength(1));
  });

  test('stale or unknown entries are consumed but ignored', () async {
    final id = await env.addTemplate();
    final task = await env.taskFor(id, oct8);
    final consumed = await env.service.applyWidgetEvents([
      ev('unknown', 9999, DateTime(2026, 10, 8, 10)),
      ev('wrong-date', task.id, DateTime(2026, 10, 8, 10), '2026-10-01'),
    ]);
    expect(consumed, {'unknown', 'wrong-date'});
    expect(await env.events(), isEmpty);
  });

  test('queue JSON round-trips and tolerates garbage', () {
    final events = [ev('a', 1, DateTime(2026, 10, 8, 10, 30))];
    final decoded = PendingWidgetEvent.decodeQueue(
      PendingWidgetEvent.encodeQueue(events),
    );
    expect(decoded.single.id, 'a');
    expect(decoded.single.occurredAt, DateTime(2026, 10, 8, 10, 30));
    expect(PendingWidgetEvent.decodeQueue('not json'), isEmpty);
    expect(
      PendingWidgetEvent.decodeQueue(
        '[{"id":1},{"id":"ok",'
        '"dailyTaskId":2,"date":"2026-10-08",'
        '"occurredAt":"2026-10-08T01:00:00Z"}]',
      ).map((e) => e.id),
      ['ok'],
    );
    expect(PendingWidgetEvent.decodeQueue(null), isEmpty);
  });
}
