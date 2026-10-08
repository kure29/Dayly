import 'package:dailyquest/app/app.dart';
import 'package:dailyquest/core/l10n/l10n.dart';
import 'package:dailyquest/domain/reminder_plan.dart';
import 'package:dailyquest/features/settings/reminders.dart';
import 'package:dailyquest/widgets_bridge/widget_sync.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/seed.dart';
import '../helpers/test_env.dart';
import '../widgets_bridge/widget_bridge_test.dart' show FakeWidgetStore;

class FakeScheduler implements ReminderScheduler {
  int applies = 0;

  @override
  Future<void> apply(List<PlannedReminder> plan, AppLocalizations l10n) async =>
      applies++;

  @override
  Future<bool> requestPermission() async => true;
}

void main() {
  testWidgets('the whole app boots, settles and survives resume', (
    tester,
  ) async {
    usePhoneViewport(tester);
    final env = TestEnv();
    await tester.runAsync(() => seedSample(env));
    final store = FakeWidgetStore();
    final scheduler = FakeScheduler();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...envOverrides(env),
          widgetStoreProvider.overrideWithValue(store),
          reminderSchedulerProvider.overrideWithValue(scheduler),
        ],
        child: const DailyQuestApp(),
      ),
    );
    // A bounded number of frames: an endless rebuild/frame loop fails here.
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 10),
    );
    expect(find.text('背单词'), findsOneWidget);

    // Let the debounced widget/reminder sync run.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(store.refreshes, greaterThan(0));

    // Simulate going to background and back.
    for (final s in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 10),
    );
    expect(find.text('背单词'), findsOneWidget);

    await unmountAndClose(tester, env);
  });
}
