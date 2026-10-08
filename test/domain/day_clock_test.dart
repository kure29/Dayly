import 'package:dailyquest/domain/local_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DayClock.logicalDate', () {
    test('before dayStartHour still counts as the previous day', () {
      expect(
        DayClock.logicalDate(DateTime(2026, 10, 9, 3, 59), 4),
        LocalDate(2026, 10, 8),
      );
    });

    test('at dayStartHour the new day begins', () {
      expect(
        DayClock.logicalDate(DateTime(2026, 10, 9, 4), 4),
        LocalDate(2026, 10, 9),
      );
    });

    test('crosses month and year boundaries', () {
      expect(
        DayClock.logicalDate(DateTime(2027, 1, 1, 1), 4),
        LocalDate(2026, 12, 31),
      );
      expect(
        DayClock.logicalDate(DateTime(2026, 3, 1, 2), 3),
        LocalDate(2026, 2, 28),
      );
    });

    test('dayStartHour 0 means midnight', () {
      expect(
        DayClock.logicalDate(DateTime(2026, 10, 9, 0, 1), 0),
        LocalDate(2026, 10, 9),
      );
    });
  });

  group('LocalDate', () {
    test('formats and parses yyyy-MM-dd', () {
      final d = LocalDate.parse('2026-03-07');
      expect(d.toString(), '2026-03-07');
      expect(d, LocalDate(2026, 3, 7));
    });

    test('arithmetic is immune to DST transitions', () {
      // 2026-03-29 is the EU DST switch; 2026-11-01 the US one.
      var d = LocalDate(2026, 3, 1);
      for (var i = 0; i < 300; i++) {
        final next = d.addDays(1);
        expect(d.daysUntil(next), 1);
        d = next;
      }
      expect(d, LocalDate(2026, 12, 26));
    });

    test('week starts on Monday', () {
      expect(LocalDate(2026, 10, 8).weekday, DateTime.thursday);
      expect(LocalDate(2026, 10, 8).startOfWeek, LocalDate(2026, 10, 5));
      expect(LocalDate(2026, 10, 11).startOfWeek, LocalDate(2026, 10, 5));
    });
  });
}
