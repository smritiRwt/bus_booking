import '../entities/trip.dart';
import '../entities/seat.dart';
import '../repositories/bus_repository.dart';

class GetTripDetailsUseCase {
  final BusRepository repository;

  GetTripDetailsUseCase(this.repository);

  Future<TripEntity?> getTrip(int tripId) {
    return repository.getTripById(tripId);
  }

  Future<List<SeatEntity>> getSeats(int tripId) {
    return repository.getSeatsForTrip(tripId);
  }
}
