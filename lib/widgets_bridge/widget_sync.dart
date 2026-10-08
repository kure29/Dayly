import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/appearance_controller.dart';
import '../app/providers.dart';
import '../domain/task_service.dart';
import '../domain/widget_events.dart';
import '../features/settings/reminders.dart';
import 'widget_snapshot.dart';
import 'widget_store.dart';

/// Pushes snapshots to the widgets and merges their queued check-ins.
class WidgetSync {
  WidgetSync(this._store, this._service);

  final WidgetStore _store;
  final TaskService _service;

  Future<void> push(Map<String, Object?> snapshot) async {
    await _store.write(WidgetKeys.snapshot, WidgetSnapshot.encode(snapshot));
    await _store.refresh();
  }

  /// Applies queued widget check-ins as `source = widget` events and removes
  /// exactly the consumed entries, so taps queued while merging survive.
  Future<int> mergePending() async {
    final events = PendingWidgetEvent.decodeQueue(
      await _store.read(WidgetKeys.pending),
    );
    if (events.isEmpty) return 0;
    final consumed = await _service.applyWidgetEvents(events);
    final latest = PendingWidgetEvent.decodeQueue(
      await _store.read(WidgetKeys.pending),
    );
    final remaining = latest.where((e) => !consumed.contains(e.id)).toList();
    await _store.write(
      WidgetKeys.pending,
      PendingWidgetEvent.encodeQueue(remaining),
    );
    return consumed.length;
  }
}

final widgetStoreProvider = Provider<WidgetStore>(
  (ref) => const HomeWidgetStore(),
);

final widgetSyncServiceProvider = Provider<WidgetSync>(
  (ref) => WidgetSync(
    ref.watch(widgetStoreProvider),
    ref.watch(taskServiceProvider),
  ),
);

/// Re-publishes the widget snapshot whenever today's tasks, the streak or
/// the appearance change. Watch it once from the app root.
final widgetSnapshotSyncProvider = Provider<void>((ref) {
  Timer? debounce;

  Future<void> publish() async {
    final date = ref.read(todayDateProvider).value;
    final tasks = ref.read(todayTasksProvider).value;
    final settings = ref.read(settingsProvider).value;
    if (date == null || tasks == null || settings == null) return;
    final l10n = ref.read(appLocalizationsProvider);
    final snapshot = WidgetSnapshot.build(
      date: date,
      tasks: tasks,
      streak: ref.read(streakProvider).value?.current ?? 0,
      scheme: ref.read(activeSchemeProvider),
      mode: settings.brightnessMode,
      title: l10n.widgetTitle,
      emptyText: l10n.noTasksToday,
      staleText: l10n.widgetStale,
      dayStartHour: settings.dayStartHour,
      generatedAt: ref.read(clockProvider)(),
    );
    try {
      await ref.read(widgetSyncServiceProvider).push(snapshot);
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stack, library: 'widgets'),
      );
    }
  }

  void schedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), publish);
  }

  ref.listen(todayTasksProvider, (_, _) => schedule());
  ref.listen(streakProvider, (_, _) => schedule());
  ref.listen(activeSchemeProvider, (_, _) => schedule());
  ref.listen(settingsProvider, (_, _) => schedule());
  ref.onDispose(() => debounce?.cancel());
});
