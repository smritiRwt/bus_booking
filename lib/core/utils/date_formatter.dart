import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dbFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('EEE, dd MMM yyyy');
  static final DateFormat _shortDisplayFormat = DateFormat('dd MMM');
  static final DateFormat _dayNameFormat = DateFormat('EEE');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

  static String toDbString(DateTime date) => _dbFormat.format(date);

  static DateTime fromDbString(String dateStr) {
    try {
      return _dbFormat.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  static String toDisplayString(DateTime date) => _displayFormat.format(date);

  static String toShortDisplay(DateTime date) => _shortDisplayFormat.format(date);

  static String toDayName(DateTime date) => _dayNameFormat.format(date);

  static String toMonthYear(DateTime date) => _monthYearFormat.format(date);

  static String toDateTimeDisplay(DateTime date) => _dateTimeFormat.format(date);

  static String formatDbStringToDisplay(String dbDate) {
    final date = fromDbString(dbDate);
    return toDisplayString(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
