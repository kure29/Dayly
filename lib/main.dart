import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/startup_error.dart';
import 'widgets_bridge/widget_callback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await registerWidgetCallbacks().timeout(const Duration(seconds: 5));
  } catch (error, stack) {
    // Widgets are optional; never block app start on them.
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
  }
  final ProviderContainer container;
  try {
    container = await bootstrap().timeout(const Duration(seconds: 20));
  } catch (error, stack) {
    runApp(StartupErrorApp(error: error, stack: stack));
    return;
  }
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DailyQuestApp(),
    ),
  );
}
