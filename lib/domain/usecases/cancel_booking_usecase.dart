import '../repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<bool> execute({
    required int bookingId,
    required String reason,
  }) {
    return repository.cancelBooking(
      bookingId: bookingId,
      reason: reason,
    );
  }
}
