import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetUserBookingsUseCase {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  Future<List<BookingEntity>> getAll(int userId) {
    return repository.getUserBookings(userId);
  }

  Future<BookingEntity?> getUpcoming(int userId) {
    return repository.getUpcomingBooking(userId);
  }

  Future<BookingEntity?> getByPnr(String pnr) {
    return repository.getBookingByPnr(pnr);
  }
}
