import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bus_booking/data/database/database_tables.dart';
import 'package:bus_booking/data/database/sample_data.dart';
import 'package:bus_booking/data/datasources/local_database_datasource.dart';
import 'package:bus_booking/data/database/app_database.dart';
import 'package:bus_booking/domain/entities/passenger.dart';

void main() {
  // Initialize ffi for running sqlite tests on desktop/host
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database db;
  late LocalDatabaseDataSource dataSource;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (database) async {
          await database.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (database, version) async {
          await database.execute(DatabaseTables.createUsersTable);
          await database.execute(DatabaseTables.createBusesTable);
          await database.execute(DatabaseTables.createRoutesTable);
          await database.execute(DatabaseTables.createTripsTable);
          await database.execute(DatabaseTables.createSeatsTable);
          await database.execute(DatabaseTables.createPassengersTable);
          await database.execute(DatabaseTables.createBookingsTable);
          await database.execute(DatabaseTables.createBookingSeatsTable);
          await database.execute(DatabaseTables.createPaymentsTable);
          for (final idx in DatabaseTables.createIndexes) {
            await database.execute(idx);
          }
          await SampleData.seedDatabase(database);
        },
      ),
    );

    dataSource = LocalDatabaseDataSource(AppDatabase.withDatabase(db));
  });

  tearDown(() async {
    await db.close();
  });

  group('SQLite Database & Booking Workflow Tests', () {
    test('Database is properly seeded with buses and routes', () async {
      final buses = await dataSource.getAllBuses();
      expect(buses.length, greaterThanOrEqualTo(10));

      final cities = await dataSource.getAllCities();
      expect(cities.contains('Delhi'), isTrue);
      expect(cities.contains('Chandigarh'), isTrue);
    });

    test('Search returns trips for seeded route', () async {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final results = await dataSource.searchTrips(
        sourceCity: 'Delhi',
        destinationCity: 'Chandigarh',
        journeyDate: dateStr,
      );

      expect(results, isNotEmpty);
      expect(results.first.bus, isNotNull);
      expect(results.first.route, isNotNull);
    });

    test('Booking confirmation reserves seats and decrements availability in transaction', () async {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final trips = await dataSource.searchTrips(
        sourceCity: 'Delhi',
        destinationCity: 'Chandigarh',
        journeyDate: dateStr,
      );

      final trip = trips.first;
      final initialAvailable = trip.availableSeatsCount;

      final seats = await dataSource.getSeatsForTrip(trip.id);
      final unbookedSeats = seats.where((s) => !s.isBooked).take(2).toList();
      expect(unbookedSeats.length, 2);

      final passengers = [
        PassengerEntity(fullName: 'Test Passenger 1', age: 24, gender: 'Male', seatNumber: unbookedSeats[0].seatNumber),
        PassengerEntity(fullName: 'Test Passenger 2', age: 22, gender: 'Female', seatNumber: unbookedSeats[1].seatNumber),
      ];

      final booking = await dataSource.confirmBooking(
        tripId: trip.id,
        userId: 1,
        contactEmail: 'test@smartbus.com',
        contactPhone: '9876543210',
        boardingPoint: 'Main ISBT',
        droppingPoint: 'City Terminal',
        seatIds: [unbookedSeats[0].id, unbookedSeats[1].id],
        passengers: passengers,
        paymentMethod: 'UPI',
        baseFare: unbookedSeats[0].price + unbookedSeats[1].price,
        convenienceFee: 40.0,
        totalAmount: unbookedSeats[0].price + unbookedSeats[1].price + 40.0,
      );

      expect(booking.pnr.startsWith('SB-'), isTrue);
      expect(booking.bookingStatus, 'CONFIRMED');

      // Verify seats are marked as booked
      final updatedSeats = await dataSource.getSeatsForTrip(trip.id);
      final booked1 = updatedSeats.firstWhere((s) => s.id == unbookedSeats[0].id);
      final booked2 = updatedSeats.firstWhere((s) => s.id == unbookedSeats[1].id);
      expect(booked1.isBooked, isTrue);
      expect(booked2.isBooked, isTrue);

      // Verify trip available count decremented
      final updatedTrip = await dataSource.getTripById(trip.id);
      expect(updatedTrip!.availableSeatsCount, initialAvailable - 2);

      // Verify duplicate reservation attempt is prevented and throws error
      expect(
        () async => await dataSource.confirmBooking(
          tripId: trip.id,
          userId: 1,
          contactEmail: 'duplicate@test.com',
          contactPhone: '9876543210',
          boardingPoint: 'Main ISBT',
          droppingPoint: 'City Terminal',
          seatIds: [unbookedSeats[0].id],
          passengers: [passengers.first],
          paymentMethod: 'UPI',
          baseFare: unbookedSeats[0].price,
          convenienceFee: 40.0,
          totalAmount: unbookedSeats[0].price + 40.0,
        ),
        throwsA(isA<Exception>()),
      );

      // Test cancellation releases seats
      final cancelSuccess = await dataSource.cancelBooking(
        bookingId: booking.id!,
        reason: 'Change of plans',
      );
      expect(cancelSuccess, isTrue);

      final reloadedSeats = await dataSource.getSeatsForTrip(trip.id);
      final released1 = reloadedSeats.firstWhere((s) => s.id == unbookedSeats[0].id);
      final released2 = reloadedSeats.firstWhere((s) => s.id == unbookedSeats[1].id);
      expect(released1.isBooked, isFalse);
      expect(released2.isBooked, isFalse);

      final reloadedTrip = await dataSource.getTripById(trip.id);
      expect(reloadedTrip!.availableSeatsCount, initialAvailable);
    });
  });
}
