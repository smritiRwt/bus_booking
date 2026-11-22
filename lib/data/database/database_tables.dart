class DatabaseTables {
  // Table Names
  static const String tableUsers = 'users';
  static const String tableBuses = 'buses';
  static const String tableRoutes = 'routes';
  static const String tableTrips = 'trips';
  static const String tableSeats = 'seats';
  static const String tablePassengers = 'passengers';
  static const String tableBookings = 'bookings';
  static const String tableBookingSeats = 'booking_seats';
  static const String tablePayments = 'payments';

  // 1. Users Table
  static const String createUsersTable = '''
    CREATE TABLE $tableUsers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL,
      created_at TEXT NOT NULL
    );
  ''';

  // 2. Buses Table
  static const String createBusesTable = '''
    CREATE TABLE $tableBuses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      operator_name TEXT NOT NULL,
      bus_type TEXT NOT NULL,
      total_seats INTEGER NOT NULL,
      rating REAL NOT NULL,
      amenities TEXT NOT NULL,
      cancellation_policy TEXT NOT NULL
    );
  ''';

  // 3. Routes Table
  static const String createRoutesTable = '''
    CREATE TABLE $tableRoutes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      source_city TEXT NOT NULL,
      destination_city TEXT NOT NULL,
      distance_km REAL NOT NULL,
      estimated_duration TEXT NOT NULL
    );
  ''';

  // 4. Trips Table
  static const String createTripsTable = '''
    CREATE TABLE $tableTrips (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bus_id INTEGER NOT NULL,
      route_id INTEGER NOT NULL,
      journey_date TEXT NOT NULL,
      departure_time TEXT NOT NULL,
      arrival_time TEXT NOT NULL,
      base_price REAL NOT NULL,
      boarding_points TEXT NOT NULL,
      dropping_points TEXT NOT NULL,
      available_seats_count INTEGER NOT NULL,
      FOREIGN KEY (bus_id) REFERENCES $tableBuses (id) ON DELETE CASCADE,
      FOREIGN KEY (route_id) REFERENCES $tableRoutes (id) ON DELETE CASCADE
    );
  ''';

  // 5. Seats Table
  static const String createSeatsTable = '''
    CREATE TABLE $tableSeats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      trip_id INTEGER NOT NULL,
      seat_number TEXT NOT NULL,
      seat_type TEXT NOT NULL,
      deck TEXT NOT NULL,
      row_index INTEGER NOT NULL,
      column_index INTEGER NOT NULL,
      price REAL NOT NULL,
      is_booked INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (trip_id) REFERENCES $tableTrips (id) ON DELETE CASCADE
    );
  ''';

  // 6. Passengers Table
  static const String createPassengersTable = '''
    CREATE TABLE $tablePassengers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      full_name TEXT NOT NULL,
      age INTEGER NOT NULL,
      gender TEXT NOT NULL,
      seat_number TEXT NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES $tableBookings (id) ON DELETE CASCADE
    );
  ''';

  // 7. Bookings Table
  static const String createBookingsTable = '''
    CREATE TABLE $tableBookings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pnr TEXT UNIQUE NOT NULL,
      trip_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      contact_email TEXT NOT NULL,
      contact_phone TEXT NOT NULL,
      total_passengers INTEGER NOT NULL,
      base_fare REAL NOT NULL,
      convenience_fee REAL NOT NULL,
      total_amount REAL NOT NULL,
      booking_status TEXT NOT NULL,
      booking_date TEXT NOT NULL,
      boarding_point TEXT NOT NULL,
      dropping_point TEXT NOT NULL,
      cancellation_reason TEXT,
      cancelled_at TEXT,
      FOREIGN KEY (trip_id) REFERENCES $tableTrips (id),
      FOREIGN KEY (user_id) REFERENCES $tableUsers (id)
    );
  ''';

  // 8. Booking Seats Table
  static const String createBookingSeatsTable = '''
    CREATE TABLE $tableBookingSeats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      seat_id INTEGER NOT NULL,
      seat_number TEXT NOT NULL,
      seat_price REAL NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES $tableBookings (id) ON DELETE CASCADE,
      FOREIGN KEY (seat_id) REFERENCES $tableSeats (id)
    );
  ''';

  // 9. Payments Table
  static const String createPaymentsTable = '''
    CREATE TABLE $tablePayments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      transaction_id TEXT UNIQUE NOT NULL,
      payment_method TEXT NOT NULL,
      amount REAL NOT NULL,
      payment_status TEXT NOT NULL,
      payment_date TEXT NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES $tableBookings (id) ON DELETE CASCADE
    );
  ''';

  // Indexes for performance
  static const List<String> createIndexes = [
    'CREATE INDEX idx_trips_date_route ON $tableTrips (journey_date, route_id);',
    'CREATE INDEX idx_seats_trip ON $tableSeats (trip_id);',
    'CREATE INDEX idx_bookings_pnr ON $tableBookings (pnr);',
    'CREATE INDEX idx_bookings_user ON $tableBookings (user_id);',
    'CREATE INDEX idx_booking_seats_booking ON $tableBookingSeats (booking_id);',
    'CREATE INDEX idx_passengers_booking ON $tablePassengers (booking_id);',
  ];
}
