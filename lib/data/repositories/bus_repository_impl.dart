import '../../domain/entities/bus.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/bus_repository.dart';
import '../datasources/local_database_datasource.dart';

class BusRepositoryImpl implements BusRepository {
  final LocalDatabaseDataSource localDataSource;

  BusRepositoryImpl(this.localDataSource);

  @override
  Future<List<TripEntity>> searchTrips({
    required String sourceCity,
    required String destinationCity,
    required String journeyDate,
    BusSearchFilter? filter,
  }) async {
    return await localDataSource.searchTrips(
      sourceCity: sourceCity,
      destinationCity: destinationCity,
      journeyDate: journeyDate,
      filter: filter,
    );
  }

  @override
  Future<TripEntity?> getTripById(int tripId) async {
    return await localDataSource.getTripById(tripId);
  }

  @override
  Future<List<SeatEntity>> getSeatsForTrip(int tripId) async {
    return await localDataSource.getSeatsForTrip(tripId);
  }

  @override
  Future<List<BusEntity>> getAllBuses() async {
    return await localDataSource.getAllBuses();
  }

  @override
  Future<List<String>> getAllCities() async {
    return await localDataSource.getAllCities();
  }
}
