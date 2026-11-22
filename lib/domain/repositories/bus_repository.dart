import '../entities/bus.dart';
import '../entities/trip.dart';
import '../entities/seat.dart';

class BusSearchFilter {
  final bool? isAc;
  final bool? isSleeper;
  final String? sortBy; // 'price_asc', 'price_desc', 'rating_desc', 'departure_asc'
  final String? departureTimeSlot; // 'morning', 'afternoon', 'evening', 'night'
  final double? minRating;

  const BusSearchFilter({
    this.isAc,
    this.isSleeper,
    this.sortBy,
    this.departureTimeSlot,
    this.minRating,
  });

  bool get hasActiveFilters =>
      isAc != null ||
      isSleeper != null ||
      sortBy != null ||
      departureTimeSlot != null ||
      minRating != null;
}

abstract class BusRepository {
  Future<List<TripEntity>> searchTrips({
    required String sourceCity,
    required String destinationCity,
    required String journeyDate, // YYYY-MM-DD
    BusSearchFilter? filter,
  });

  Future<TripEntity?> getTripById(int tripId);

  Future<List<SeatEntity>> getSeatsForTrip(int tripId);

  Future<List<BusEntity>> getAllBuses();

  Future<List<String>> getAllCities();
}
