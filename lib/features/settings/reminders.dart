import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/l10n/l10n.dart';
import '../../domain/reminder_plan.dart';

/// Schedules local notifications. Abstract so tests can use a fake.
abstract interface class ReminderScheduler {
  Future<bool> requestPermission();

  Future<void> apply(List<PlannedReminder> plan, AppLocalizations l10n);
}

class LocalNotificationScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _init;

  Future<void> _ensureInit() => _init ??= () async {
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      // Fall back to UTC offsets via tz.local's default.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  @override
  Future<bool> requestPermission() async {
    await _ensureInit();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, sound: true) ??
        false;
  }

  @override
  Future<void> apply(List<PlannedReminder> plan, AppLocalizations l10n) async {
    await _ensureInit();
    for (final id in ReminderPlanner.allIds) {
      await _plugin.cancel(id: id);
    }
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder',
        l10n.reminder,
        importance: Importance.defaultImportance,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    for (final r in plan) {
      await _plugin.zonedSchedule(
        id: r.id,
        scheduledDate: tz.TZDateTime.from(r.at, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: l10n.appTitle,
        body: r.remaining == null
            ? l10n.reminderBodyGeneric
            : l10n.reminderBody(r.remaining!),
      );
    }
  }
}

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalNotificationScheduler(),
);

/// Locale-resolved strings for code that runs outside the widget tree.
final appLocalizationsProvider = Provider<AppLocalizations>(
  (ref) => lookupAppLocalizations(
    resolveAppLocale(
      PlatformDispatcher.instance.locale,
      AppLocalizations.supportedLocales,
    ),
  ),
);

/// Keeps scheduled reminders in sync with settings and today's progress.
/// Watch it once from the app root.
final reminderSyncProvider = Provider<void>((ref) {
  Timer? debounce;
  Future<void> resync() async {
    final settings = await ref.read(settingsProvider.future);
    final today = ref.read(todayTasksProvider).value ?? const [];
    final templates = ref.read(templatesProvider).value ?? const [];
    final plan = ReminderPlanner.plan(
      settings: settings,
      now: ref.read(clockProvider)(),
      remainingToday: today.where((t) => !t.task.isCompleted).length,
      templates: templates,
    );
    try {
      await ref
          .read(reminderSchedulerProvider)
          .apply(plan, ref.read(appLocalizationsProvider));
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'reminders',
        ),
      );
    }
  }

  void schedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 400), resync);
  }

  ref.listen(settingsProvider, (_, _) => schedule());
  ref.listen(todayTasksProvider, (_, _) => schedule());
  ref.listen(templatesProvider, (_, _) => schedule());
  ref.onDispose(() => debounce?.cancel());
});
