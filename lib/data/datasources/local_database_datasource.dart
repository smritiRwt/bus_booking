import 'package:sqflite/sqflite.dart';
import '../../core/utils/pnr_generator.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/repositories/bus_repository.dart';
import '../database/app_database.dart';
import '../database/database_tables.dart';
import '../models/booking_model.dart';
import '../models/bus_model.dart';
import '../models/passenger_model.dart';
import '../models/route_model.dart';
import '../models/seat_model.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';

class LocalDatabaseDataSource {
  final AppDatabase _appDatabase;

  LocalDatabaseDataSource(this._appDatabase);

  Future<Database> get _db => _appDatabase.database;

  // -------------------------------------------------------------
  // TRIPS & BUSES
  // -------------------------------------------------------------

  Future<List<TripModel>> searchTrips({
    required String sourceCity,
    required String destinationCity,
    required String journeyDate,
    BusSearchFilter? filter,
  }) async {
    final db = await _db;

    final whereClauses = <String>[
      'r.source_city LIKE ?',
      'r.destination_city LIKE ?',
      't.journey_date = ?',
    ];
    final whereArgs = <dynamic>[
      '%$sourceCity%',
      '%$destinationCity%',
      journeyDate,
    ];

    if (filter != null) {
      if (filter.isAc != null) {
        if (filter.isAc!) {
          whereClauses.add("b.bus_type NOT LIKE '%Non-AC%' AND b.bus_type LIKE '%AC%'");
        } else {
          whereClauses.add("b.bus_type LIKE '%Non-AC%'");
        }
      }

      if (filter.isSleeper != null) {
        if (filter.isSleeper!) {
          whereClauses.add("b.bus_type LIKE '%Sleeper%'");
        } else {
          whereClauses.add("b.bus_type LIKE '%Seater%'");
        }
      }

      if (filter.minRating != null) {
        whereClauses.add('b.rating >= ?');
        whereArgs.add(filter.minRating);
      }
    }

    String orderBy = 't.departure_time ASC';
    if (filter?.sortBy != null) {
      switch (filter!.sortBy) {
        case 'price_asc':
          orderBy = 't.base_price ASC';
          break;
        case 'price_desc':
          orderBy = 't.base_price DESC';
          break;
        case 'rating_desc':
          orderBy = 'b.rating DESC';
          break;
        case 'departure_asc':
        default:
          orderBy = 't.departure_time ASC';
          break;
      }
    }

    final query = '''
      SELECT 
        t.*,
        b.name AS bus_name,
        b.operator_name AS bus_operator,
        b.bus_type AS bus_type,
        b.total_seats AS bus_total_seats,
        b.rating AS bus_rating,
        b.amenities AS bus_amenities,
        b.cancellation_policy AS bus_cancellation_policy,
        r.source_city AS route_source,
        r.destination_city AS route_destination,
        r.distance_km AS route_distance,
        r.estimated_duration AS route_duration
      FROM ${DatabaseTables.tableTrips} t
      INNER JOIN ${DatabaseTables.tableBuses} b ON t.bus_id = b.id
      INNER JOIN ${DatabaseTables.tableRoutes} r ON t.route_id = r.id
      WHERE ${whereClauses.join(' AND ')}
      ORDER BY $orderBy
    ''';

    final results = await db.rawQuery(query, whereArgs);

    final trips = results.map((row) {
      final bus = BusModel(
        id: row['bus_id'] as int,
        name: row['bus_name'] as String,
        operatorName: row['bus_operator'] as String,
        busType: row['bus_type'] as String,
        totalSeats: row['bus_total_seats'] as int,
        rating: (row['bus_rating'] as num).toDouble(),
        amenities: BusModel.parseAmenities(row['bus_amenities']),
        cancellationPolicy: row['bus_cancellation_policy'] as String,
      );

      final route = RouteModel(
        id: row['route_id'] as int,
        sourceCity: row['route_source'] as String,
        destinationCity: row['route_destination'] as String,
        distanceKm: (row['route_distance'] as num).toDouble(),
        estimatedDuration: row['route_duration'] as String,
      );

      return TripModel.fromMap(row, bus: bus, route: route);
    }).toList();

    // In-memory filter for departure time slot if specified
    if (filter?.departureTimeSlot != null && filter!.departureTimeSlot!.isNotEmpty) {
      return trips.where((trip) {
        return _matchesDepartureSlot(trip.departureTime, filter.departureTimeSlot!);
      }).toList();
    }

    return trips;
  }

  bool _matchesDepartureSlot(String timeStr, String slot) {
    // E.g. "06:30 AM" or "10:45 PM"
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      switch (slot.toLowerCase()) {
        case 'morning': // 06:00 to 11:59
          return hour >= 6 && hour < 12;
        case 'afternoon': // 12:00 to 17:59
          return hour >= 12 && hour < 18;
        case 'evening': // 18:00 to 23:59
          return hour >= 18 && hour < 24;
        case 'night': // 00:00 to 05:59
          return hour >= 0 && hour < 6;
      }
    } catch (_) {}
    return true;
  }

  Future<TripModel?> getTripById(int tripId, [DatabaseExecutor? executor]) async {
    final db = executor ?? await _db;
    final query = '''
      SELECT 
        t.*,
        b.name AS bus_name,
        b.operator_name AS bus_operator,
        b.bus_type AS bus_type,
        b.total_seats AS bus_total_seats,
        b.rating AS bus_rating,
        b.amenities AS bus_amenities,
        b.cancellation_policy AS bus_cancellation_policy,
        r.source_city AS route_source,
        r.destination_city AS route_destination,
        r.distance_km AS route_distance,
        r.estimated_duration AS route_duration
      FROM ${DatabaseTables.tableTrips} t
      INNER JOIN ${DatabaseTables.tableBuses} b ON t.bus_id = b.id
      INNER JOIN ${DatabaseTables.tableRoutes} r ON t.route_id = r.id
      WHERE t.id = ?
    ''';
    final results = await db.rawQuery(query, [tripId]);
    if (results.isEmpty) return null;

    final row = results.first;
    final bus = BusModel(
      id: row['bus_id'] as int,
      name: row['bus_name'] as String,
      operatorName: row['bus_operator'] as String,
      busType: row['bus_type'] as String,
      totalSeats: row['bus_total_seats'] as int,
      rating: (row['bus_rating'] as num).toDouble(),
      amenities: BusModel.parseAmenities(row['bus_amenities']),
      cancellationPolicy: row['bus_cancellation_policy'] as String,
    );

    final route = RouteModel(
      id: row['route_id'] as int,
      sourceCity: row['route_source'] as String,
      destinationCity: row['route_destination'] as String,
      distanceKm: (row['route_distance'] as num).toDouble(),
      estimatedDuration: row['route_duration'] as String,
    );

    return TripModel.fromMap(row, bus: bus, route: route);
  }

  Future<List<SeatModel>> getSeatsForTrip(int tripId) async {
    final db = await _db;
    final results = await db.query(
      DatabaseTables.tableSeats,
      where: 'trip_id = ?',
      whereArgs: [tripId],
      orderBy: 'deck ASC, row_index ASC, column_index ASC',
    );
    return results.map((row) => SeatModel.fromMap(row)).toList();
  }

  Future<List<BusModel>> getAllBuses() async {
    final db = await _db;
    final results = await db.query(DatabaseTables.tableBuses);
    return results.map((row) => BusModel.fromMap(row)).toList();
  }

  Future<List<String>> getAllCities() async {
    final db = await _db;
    final sources = await db.rawQuery(
      'SELECT DISTINCT source_city as city FROM ${DatabaseTables.tableRoutes}',
    );
    final destinations = await db.rawQuery(
      'SELECT DISTINCT destination_city as city FROM ${DatabaseTables.tableRoutes}',
    );

    final cities = <String>{};
    for (final row in sources) {
      if (row['city'] != null) cities.add(row['city'] as String);
    }
    for (final row in destinations) {
      if (row['city'] != null) cities.add(row['city'] as String);
    }
    return cities.toList()..sort();
  }

  // -------------------------------------------------------------
  // BOOKINGS & TRANSACTIONS
  // -------------------------------------------------------------

  /// Confirms a booking atomically inside an SQLite transaction
  Future<BookingModel> confirmBooking({
    required int tripId,
    required int userId,
    required String contactEmail,
    required String contactPhone,
    required String boardingPoint,
    required String droppingPoint,
    required List<int> seatIds,
    required List<PassengerEntity> passengers,
    required String paymentMethod,
    required double baseFare,
    required double convenienceFee,
    required double totalAmount,
  }) async {
    final db = await _db;

    return await db.transaction<BookingModel>((txn) async {
      // 1. Availability check inside transaction
      final placeholders = List.filled(seatIds.length, '?').join(',');
      final checkSeats = await txn.rawQuery(
        'SELECT * FROM ${DatabaseTables.tableSeats} WHERE id IN ($placeholders) AND is_booked = 1',
        seatIds,
      );

      if (checkSeats.isNotEmpty) {
        final bookedNumbers = checkSeats.map((s) => s['seat_number']).join(', ');
        throw Exception('Seat(s) $bookedNumbers are already booked. Please choose another seat.');
      }

      // 2. Fetch full seat records for price and seat numbers
      final seatsData = await txn.rawQuery(
        'SELECT * FROM ${DatabaseTables.tableSeats} WHERE id IN ($placeholders)',
        seatIds,
      );

      // 3. Insert Booking
      final pnr = PnrGenerator.generate();
      final now = DateTime.now().toIso8601String();

      final bookingMap = <String, dynamic>{
        'pnr': pnr,
        'trip_id': tripId,
        'user_id': userId,
        'contact_email': contactEmail,
        'contact_phone': contactPhone,
        'total_passengers': passengers.length,
        'base_fare': baseFare,
        'convenience_fee': convenienceFee,
        'total_amount': totalAmount,
        'booking_status': 'CONFIRMED',
        'booking_date': now,
        'boarding_point': boardingPoint,
        'dropping_point': droppingPoint,
      };

      final bookingId = await txn.insert(DatabaseTables.tableBookings, bookingMap);

      // 4. Insert Booking Seats & Mark Seats as Booked
      final bookingSeatsList = <BookingSeatModel>[];
      for (final seatRow in seatsData) {
        final seatId = seatRow['id'] as int;
        final seatNum = seatRow['seat_number'] as String;
        final seatPrice = (seatRow['price'] as num).toDouble();

        final bsId = await txn.insert(DatabaseTables.tableBookingSeats, {
          'booking_id': bookingId,
          'seat_id': seatId,
          'seat_number': seatNum,
          'seat_price': seatPrice,
        });

        bookingSeatsList.add(BookingSeatModel(
          id: bsId,
          bookingId: bookingId,
          seatId: seatId,
          seatNumber: seatNum,
          seatPrice: seatPrice,
        ));
      }

      // Set is_booked = 1
      await txn.rawUpdate(
        'UPDATE ${DatabaseTables.tableSeats} SET is_booked = 1 WHERE id IN ($placeholders)',
        seatIds,
      );

      // 5. Update Trip available seats count
      await txn.rawUpdate(
        'UPDATE ${DatabaseTables.tableTrips} SET available_seats_count = available_seats_count - ? WHERE id = ?',
        [seatIds.length, tripId],
      );

      // 6. Insert Passengers
      final passengerModels = <PassengerModel>[];
      for (final p in passengers) {
        final pId = await txn.insert(DatabaseTables.tablePassengers, {
          'booking_id': bookingId,
          'full_name': p.fullName,
          'age': p.age,
          'gender': p.gender,
          'seat_number': p.seatNumber,
        });

        passengerModels.add(PassengerModel(
          id: pId,
          bookingId: bookingId,
          fullName: p.fullName,
          age: p.age,
          gender: p.gender,
          seatNumber: p.seatNumber,
        ));
      }

      // 7. Insert Payment record
      final txnId = PnrGenerator.generateTransactionId();
      await txn.insert(DatabaseTables.tablePayments, {
        'booking_id': bookingId,
        'transaction_id': txnId,
        'payment_method': paymentMethod,
        'amount': totalAmount,
        'payment_status': 'SUCCESS',
        'payment_date': now,
      });

      // 8. Return constructed booking model with details
      final trip = await getTripById(tripId, txn);

      return BookingModel(
        id: bookingId,
        pnr: pnr,
        tripId: tripId,
        userId: userId,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
        totalPassengers: passengers.length,
        baseFare: baseFare,
        convenienceFee: convenienceFee,
        totalAmount: totalAmount,
        bookingStatus: 'CONFIRMED',
        bookingDate: now,
        boardingPoint: boardingPoint,
        droppingPoint: droppingPoint,
        trip: trip,
        passengers: passengerModels,
        bookingSeats: bookingSeatsList,
      );
    });
  }

  /// Cancels booking atomically, releasing seats and restoring availability
  Future<bool> cancelBooking({
    required int bookingId,
    required String reason,
  }) async {
    final db = await _db;

    return await db.transaction<bool>((txn) async {
      // 1. Get booking
      final bookings = await txn.query(
        DatabaseTables.tableBookings,
        where: 'id = ?',
        whereArgs: [bookingId],
      );
      if (bookings.isEmpty) return false;

      final booking = bookings.first;
      if (booking['booking_status'] == 'CANCELLED') {
        return true; // Already cancelled
      }

      final tripId = booking['trip_id'] as int;
      final now = DateTime.now().toIso8601String();

      // 2. Update booking status
      await txn.update(
        DatabaseTables.tableBookings,
        {
          'booking_status': 'CANCELLED',
          'cancellation_reason': reason,
          'cancelled_at': now,
        },
        where: 'id = ?',
        whereArgs: [bookingId],
      );

      // 3. Find booked seats
      final bookingSeats = await txn.query(
        DatabaseTables.tableBookingSeats,
        where: 'booking_id = ?',
        whereArgs: [bookingId],
      );

      final seatIds = bookingSeats.map((bs) => bs['seat_id'] as int).toList();

      if (seatIds.isNotEmpty) {
        final placeholders = List.filled(seatIds.length, '?').join(',');

        // 4. Release seats in seats table
        await txn.rawUpdate(
          'UPDATE ${DatabaseTables.tableSeats} SET is_booked = 0 WHERE id IN ($placeholders)',
          seatIds,
        );

        // 5. Restore available seats in trips table
        await txn.rawUpdate(
          'UPDATE ${DatabaseTables.tableTrips} SET available_seats_count = available_seats_count + ? WHERE id = ?',
          [seatIds.length, tripId],
        );
      }

      return true;
    });
  }

  Future<BookingModel?> getBookingById(int bookingId) async {
    final db = await _db;
    final results = await db.query(
      DatabaseTables.tableBookings,
      where: 'id = ?',
      whereArgs: [bookingId],
    );
    if (results.isEmpty) return null;
    return _populateBookingDetails(results.first);
  }

  Future<BookingModel?> getBookingByPnr(String pnr) async {
    final db = await _db;
    final results = await db.query(
      DatabaseTables.tableBookings,
      where: 'pnr = ?',
      whereArgs: [pnr.trim().toUpperCase()],
    );
    if (results.isEmpty) return null;
    return _populateBookingDetails(results.first);
  }

  Future<List<BookingModel>> getUserBookings(int userId) async {
    final db = await _db;
    final results = await db.query(
      DatabaseTables.tableBookings,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    final bookings = <BookingModel>[];
    for (final row in results) {
      final b = await _populateBookingDetails(row);
      if (b != null) bookings.add(b);
    }
    return bookings;
  }

  Future<BookingModel?> getUpcomingBooking(int userId) async {
    final allBookings = await getUserBookings(userId);
    final upcomingList = allBookings.where((b) => b.isConfirmed && b.canBeCancelled).toList();
    if (upcomingList.isEmpty) return null;
    return upcomingList.first;
  }

  Future<BookingModel?> _populateBookingDetails(Map<String, dynamic> row) async {
    final db = await _db;
    final bookingId = row['id'] as int;
    final tripId = row['trip_id'] as int;

    final trip = await getTripById(tripId);

    final passengerRows = await db.query(
      DatabaseTables.tablePassengers,
      where: 'booking_id = ?',
      whereArgs: [bookingId],
    );
    final passengers = passengerRows.map((p) => PassengerModel.fromMap(p)).toList();

    final seatRows = await db.query(
      DatabaseTables.tableBookingSeats,
      where: 'booking_id = ?',
      whereArgs: [bookingId],
    );
    final bookingSeats = seatRows.map((s) => BookingSeatModel.fromMap(s)).toList();

    return BookingModel.fromMap(
      row,
      trip: trip,
      passengers: passengers,
      bookingSeats: bookingSeats,
    );
  }

  // -------------------------------------------------------------
  // USERS
  // -------------------------------------------------------------

  Future<UserModel?> getUserById(int id) async {
    final db = await _db;
    final results = await db.query(
      DatabaseTables.tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return UserModel.fromMap(results.first);
  }

  Future<UserModel> updateUser(UserModel user) async {
    final db = await _db;
    await db.update(
      DatabaseTables.tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return user;
  }
}
