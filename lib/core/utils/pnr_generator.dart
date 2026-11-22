import 'dart:math';

class PnrGenerator {
  static final Random _random = Random();

  /// Generates a unique, professional PNR like "SB-749201"
  static String generate() {
    final number = 100000 + _random.nextInt(900000);
    return 'SB-$number';
  }

  /// Generates a realistic transaction ID like "TXN-847291038"
  static String generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
    final randomPart = 1000 + _random.nextInt(9000);
    return 'TXN-$timestamp$randomPart';
  }

  /// Generates a booking reference ID like "BK-20261122-839"
  static String generateBookingId() {
    final now = DateTime.now();
    final datePart = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final randomPart = 100 + _random.nextInt(900);
    return 'BK-$datePart-$randomPart';
  }
}
