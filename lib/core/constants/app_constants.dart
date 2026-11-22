class AppConstants {
  static const String appName = 'SmartBus';
  static const String appTagline = 'Your Smart Travel Companion';
  static const String appVersion = '1.0.0';

  // Booking Constraints
  static const int maxSeatsPerBooking = 6;
  static const double convenienceFee = 40.0;
  static const double gstRatePercent = 5.0;

  // Database
  static const String databaseName = 'smartbus.db';
  static const int databaseVersion = 1;

  // Indian Cities for routes
  static const List<String> popularCities = [
    'Delhi',
    'Chandigarh',
    'Jaipur',
    'Amritsar',
    'Ludhiana',
    'Manali',
    'Shimla',
    'Dehradun',
    'Jalandhar',
  ];

  // Bus Types
  static const String acSleeper = 'AC Sleeper';
  static const String nonAcSleeper = 'Non-AC Sleeper';
  static const String acSeater = 'AC Seater';
  static const String nonAcSeater = 'Non-AC Seater';

  static const List<String> busTypes = [
    acSleeper,
    nonAcSleeper,
    acSeater,
    nonAcSeater,
  ];

  // Booking Statuses
  static const String statusConfirmed = 'CONFIRMED';
  static const String statusCancelled = 'CANCELLED';
  static const String statusCompleted = 'COMPLETED';

  // Payment Statuses
  static const String paymentSuccess = 'SUCCESS';
  static const String paymentFailed = 'FAILED';
  static const String paymentPending = 'PENDING';

  // Shared Preferences Keys
  static const String prefKeyIsDatabaseSeeded = 'is_database_seeded';
  static const String prefKeyCurrentUserId = 'current_user_id';
  static const String prefKeyUserName = 'user_name';
  static const String prefKeyUserEmail = 'user_email';
  static const String prefKeyUserPhone = 'user_phone';
}
