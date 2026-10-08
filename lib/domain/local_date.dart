/// A calendar date without time or zone, serialized as `yyyy-MM-dd`.
///
/// Arithmetic is done on UTC midnights so daylight-saving changes never skip
/// or repeat a day.
class LocalDate implements Comparable<LocalDate> {
  LocalDate(int year, int month, int day)
    : _utc = DateTime.utc(year, month, day);

  LocalDate._(this._utc);

  factory LocalDate.fromDateTime(DateTime dt) =>
      LocalDate(dt.year, dt.month, dt.day);

  /// Parses `yyyy-MM-dd`.
  factory LocalDate.parse(String value) {
    final parts = value.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date "$value"');
    }
    return LocalDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  final DateTime _utc;

  int get year => _utc.year;
  int get month => _utc.month;
  int get day => _utc.day;

  /// ISO weekday: Monday = 1 … Sunday = 7.
  int get weekday => _utc.weekday;

  LocalDate addDays(int days) => LocalDate._(_utc.add(Duration(days: days)));

  /// Whole days from this date to [other] (positive when [other] is later).
  int daysUntil(LocalDate other) => other._utc.difference(_utc).inDays;

  /// Monday of this date's week.
  LocalDate get startOfWeek => addDays(1 - weekday);

  /// Local midnight of this date (for APIs that want a [DateTime]).
  DateTime toDateTime() => DateTime(year, month, day);

  bool isBefore(LocalDate other) => _utc.isBefore(other._utc);
  bool isAfter(LocalDate other) => _utc.isAfter(other._utc);

  @override
  int compareTo(LocalDate other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) => other is LocalDate && other._utc == _utc;

  @override
  int get hashCode => _utc.hashCode;

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}'
      '-${day.toString().padLeft(2, '0')}';
}

/// Maps wall-clock time to the "logical" day the user is living in.
abstract final class DayClock {
  /// Before [dayStartHour] (e.g. 04:00) a moment still belongs to the
  /// previous day, so late-night check-ins count for "today".
  static LocalDate logicalDate(DateTime moment, int dayStartHour) {
    assert(dayStartHour >= 0 && dayStartHour < 24);
    final local = moment.toLocal();
    final date = LocalDate.fromDateTime(local);
    return local.hour < dayStartHour ? date.addDays(-1) : date;
  }

  /// The wall-clock moment at which [date] begins.
  static DateTime startOf(LocalDate date, int dayStartHour) =>
      DateTime(date.year, date.month, date.day, dayStartHour);
}
