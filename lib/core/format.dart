import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware number/date formatting helpers.
extension FormatContext on BuildContext {
  String get _locale => Localizations.localeOf(this).toLanguageTag();

  /// 2340 → "2,340".
  String amount(int value) =>
      NumberFormat.decimalPattern(_locale).format(value);

  /// "10月8日 星期四" / "Thursday, October 8".
  String longDate(DateTime date) => DateFormat.MMMMEEEEd(_locale).format(date);

  /// "周四" / "Thu".
  String shortWeekday(DateTime date) => DateFormat.E(_locale).format(date);

  /// "20:30".
  String timeOfDay(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}
