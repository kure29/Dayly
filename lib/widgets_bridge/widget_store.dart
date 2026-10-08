import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'widget_snapshot.dart';

/// Shared key/value storage visible to the native widgets.
abstract interface class WidgetStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);

  /// Asks every widget to redraw from storage.
  Future<void> refresh();
}

/// [WidgetStore] backed by `home_widget` (Android SharedPreferences,
/// iOS App Group UserDefaults).
class HomeWidgetStore implements WidgetStore {
  const HomeWidgetStore();

  static Future<void> init() => HomeWidget.setAppGroupId(WidgetKeys.appGroupId);

  @override
  Future<String?> read(String key) => HomeWidget.getWidgetData<String>(key);

  @override
  Future<void> write(String key, String? value) =>
      HomeWidget.saveWidgetData<String>(key, value);

  @override
  Future<void> refresh() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      for (final name in WidgetKeys.androidProviders) {
        await HomeWidget.updateWidget(qualifiedAndroidName: name);
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await HomeWidget.updateWidget(iOSName: WidgetKeys.iOSKind);
    }
  }
}
