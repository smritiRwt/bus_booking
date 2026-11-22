import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';
import 'database_tables.dart';
import 'sample_data.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase.internal();
  factory AppDatabase() => _instance;
  AppDatabase.internal();

  AppDatabase.withDatabase(Database db) {
    _database = db;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await _createTables(db);
        await SampleData.seedDatabase(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle migrations if needed in future
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(DatabaseTables.createUsersTable);
    await db.execute(DatabaseTables.createBusesTable);
    await db.execute(DatabaseTables.createRoutesTable);
    await db.execute(DatabaseTables.createTripsTable);
    await db.execute(DatabaseTables.createSeatsTable);
    await db.execute(DatabaseTables.createPassengersTable);
    await db.execute(DatabaseTables.createBookingsTable);
    await db.execute(DatabaseTables.createBookingSeatsTable);
    await db.execute(DatabaseTables.createPaymentsTable);

    for (final indexQuery in DatabaseTables.createIndexes) {
      await db.execute(indexQuery);
    }
  }

  /// For testing or resetting database
  Future<void> clearAndReseed() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(DatabaseTables.tablePayments);
      await txn.delete(DatabaseTables.tableBookingSeats);
      await txn.delete(DatabaseTables.tablePassengers);
      await txn.delete(DatabaseTables.tableBookings);
      await txn.delete(DatabaseTables.tableSeats);
      await txn.delete(DatabaseTables.tableTrips);
      await txn.delete(DatabaseTables.tableRoutes);
      await txn.delete(DatabaseTables.tableBuses);
      await txn.delete(DatabaseTables.tableUsers);
    });
    await SampleData.seedDatabase(db);
  }
}
