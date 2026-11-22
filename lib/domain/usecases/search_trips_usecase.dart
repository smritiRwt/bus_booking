import '../entities/trip.dart';
import '../repositories/bus_repository.dart';

class SearchTripsUseCase {
  final BusRepository repository;

  SearchTripsUseCase(this.repository);

  Future<List<TripEntity>> execute({
    required String sourceCity,
    required String destinationCity,
    required String journeyDate,
    BusSearchFilter? filter,
  }) {
    return repository.searchTrips(
      sourceCity: sourceCity,
      destinationCity: destinationCity,
      journeyDate: journeyDate,
      filter: filter,
    );
  }
}
