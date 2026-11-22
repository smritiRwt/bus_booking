import '../entities/booking.dart';
import '../entities/passenger.dart';

abstract class BookingRepository {
  /// Confirms a booking in a database transaction, verifying seats first and updating availability
  Future<BookingEntity> confirmBooking({
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
  });

  /// Cancels booking in transaction, releases seats, restores trip availability
  Future<bool> cancelBooking({
    required int bookingId,
    required String reason,
  });

  Future<BookingEntity?> getBookingById(int bookingId);

  Future<BookingEntity?> getBookingByPnr(String pnr);

  Future<List<BookingEntity>> getUserBookings(int userId);

  Future<BookingEntity?> getUpcomingBooking(int userId);
}
