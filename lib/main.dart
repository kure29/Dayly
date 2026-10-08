import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'widgets_bridge/widget_callback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await registerWidgetCallbacks();
  } catch (error, stack) {
    // Widgets are optional; never block app start on them.
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
  }
  final container = await bootstrap();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DailyQuestApp(),
    ),
  );
}
