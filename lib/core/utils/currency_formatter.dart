import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _decimalCurrencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num amount) {
    if (amount % 1 == 0) {
      return _currencyFormat.format(amount);
    }
    return _decimalCurrencyFormat.format(amount);
  }

  static String formatWithoutSymbol(num amount) {
    return NumberFormat.decimalPattern('en_IN').format(amount);
  }
}
