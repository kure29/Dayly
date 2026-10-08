import 'dart:convert';
import 'dart:math';

import '../domain/widget_events.dart';
import 'widget_snapshot.dart';

/// Result of a check-in tapped on a widget.
class WidgetTapResult {
  const WidgetTapResult({
    required this.snapshot,
    required this.queue,
    required this.event,
  });

  /// Snapshot with the optimistic +step applied (shown immediately).
  final String? snapshot;

  /// Pending queue with the new event appended.
  final String queue;

  /// `null` if the tap was ignored (unknown task or already complete).
  final PendingWidgetEvent? event;
}

/// Pure logic shared by the Android background callback (and mirrored in
/// Swift for iOS AppIntents): append an "advance" event to the pending queue
/// and optimistically bump the task in the snapshot.
abstract final class WidgetTap {
  static Uri checkInUri(int dailyTaskId, String date) => Uri(
    scheme: WidgetKeys.scheme,
    host: WidgetKeys.checkInHost,
    queryParameters: {'task': '$dailyTaskId', 'date': date},
  );

  /// Parses `dailyquest://checkin?task=12&date=2026-10-08`.
  static (int, String)? parse(Uri? uri) {
    if (uri == null || uri.host != WidgetKeys.checkInHost) return null;
    final id = int.tryParse(uri.queryParameters['task'] ?? '');
    final date = uri.queryParameters['date'];
    if (id == null || date == null) return null;
    return (id, date);
  }

  static WidgetTapResult apply({
    required String? snapshotJson,
    required String? queueJson,
    required int dailyTaskId,
    required String date,
    required DateTime now,
    String? eventId,
  }) {
    final queue = PendingWidgetEvent.decodeQueue(queueJson);
    Map<String, Object?>? snapshot;
    try {
      final decoded = snapshotJson == null ? null : jsonDecode(snapshotJson);
      if (decoded is Map<String, Object?>) snapshot = decoded;
    } on FormatException {
      snapshot = null;
    }

    Map<String, Object?>? task;
    if (snapshot != null && snapshot['date'] == date) {
      for (final t in (snapshot['tasks'] as List<Object?>? ?? const [])) {
        if (t is Map<String, Object?> && t['id'] == dailyTaskId) task = t;
      }
    }
    // Ignore taps on tasks the widget no longer shows or already finished.
    if (task == null || task['done'] == true) {
      return WidgetTapResult(
        snapshot: snapshotJson,
        queue: PendingWidgetEvent.encodeQueue(queue),
        event: null,
      );
    }

    final target = (task['target']! as num).toInt();
    final step = (task['step']! as num).toInt();
    final progress = ((task['progress']! as num).toInt() + step).clamp(
      0,
      target,
    );
    task['progress'] = progress;
    if (progress >= target) {
      task['done'] = true;
      snapshot!['done'] = (snapshot['done']! as num).toInt() + 1;
    }

    final event = PendingWidgetEvent(
      id: eventId ?? _newId(now),
      dailyTaskId: dailyTaskId,
      date: date,
      occurredAt: now,
    );
    return WidgetTapResult(
      snapshot: jsonEncode(snapshot),
      queue: PendingWidgetEvent.encodeQueue([...queue, event]),
      event: event,
    );
  }

  static final _random = Random.secure();

  static String _newId(DateTime now) =>
      '${now.microsecondsSinceEpoch.toRadixString(36)}-'
      '${_random.nextInt(1 << 32).toRadixString(36)}';
}
