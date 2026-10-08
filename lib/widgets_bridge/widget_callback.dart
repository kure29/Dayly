import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import 'widget_snapshot.dart';
import 'widget_store.dart';
import 'widget_tap.dart';

/// Android: runs in a background isolate when a widget "+" is tapped.
///
/// It never touches the database (the app may not be running); it appends
/// the check-in to the shared pending queue, applies the step to the
/// snapshot so the widget updates instantly, and refreshes the widgets. The
/// app merges the queue into the database on its next launch / resume.
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  WidgetsFlutterBinding.ensureInitialized();
  final tap = WidgetTap.parse(uri);
  if (tap == null) return;
  final (taskId, date) = tap;
  const store = HomeWidgetStore();
  await HomeWidgetStore.init();
  final result = WidgetTap.apply(
    snapshotJson: await store.read(WidgetKeys.snapshot),
    queueJson: await store.read(WidgetKeys.pending),
    dailyTaskId: taskId,
    date: date,
    now: DateTime.now(),
  );
  if (result.event == null) return;
  await store.write(WidgetKeys.pending, result.queue);
  await store.write(WidgetKeys.snapshot, result.snapshot);
  await store.refresh();
}

/// Sets the App Group and, on Android, registers [widgetBackgroundCallback].
/// iOS widgets check in natively through an AppIntent (see
/// `ios/DailyQuestWidget/CheckInIntent.swift`) that writes the same queue.
Future<void> registerWidgetCallbacks() async {
  await HomeWidgetStore.init();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  }
}
