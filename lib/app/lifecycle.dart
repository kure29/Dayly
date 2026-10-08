import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import '../widgets_bridge/widget_sync.dart';
import 'providers.dart';

/// Callbacks run when the app starts and whenever it returns to the
/// foreground (e.g. merging widget check-ins). Registered by feature
/// modules via [foregroundTasksProvider].
typedef ForegroundTask = Future<void> Function(ProviderContainer container);

final foregroundTasksProvider = Provider<List<ForegroundTask>>(
  (ref) => [
    // Merge check-ins made on home-screen widgets while we were away.
    (container) => container.read(widgetSyncServiceProvider).mergePending(),
  ],
);

/// Keeps "today" correct: bumps [dayTickProvider] on resume and at the next
/// day cut-over (dayStartHour), and runs [foregroundTasksProvider].
class AppLifecycleBinder extends ConsumerStatefulWidget {
  const AppLifecycleBinder({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLifecycleBinder> createState() => _AppLifecycleBinderState();
}

class _AppLifecycleBinderState extends ConsumerState<AppLifecycleBinder> {
  late final AppLifecycleListener _listener;
  Timer? _cutover;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _onForeground);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onForeground());
  }

  Future<void> _onForeground() async {
    if (!mounted) return;
    ref.read(dayTickProvider.notifier).bump();
    final container = ProviderScope.containerOf(context, listen: false);
    for (final task in ref.read(foregroundTasksProvider)) {
      try {
        await task(container);
      } catch (error, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(exception: error, stack: stack),
        );
      }
    }
    await _scheduleCutover();
  }

  Future<void> _scheduleCutover() async {
    _cutover?.cancel();
    final settings = await ref.read(settingsRepositoryProvider).loadSettings();
    final now = ref.read(clockProvider)();
    final today = DayClock.logicalDate(now, settings.dayStartHour);
    final next = DayClock.startOf(today.addDays(1), settings.dayStartHour);
    if (!mounted) return;
    _cutover = Timer(next.difference(now) + const Duration(seconds: 1), () {
      if (mounted) _onForeground();
    });
  }

  @override
  void dispose() {
    _cutover?.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
