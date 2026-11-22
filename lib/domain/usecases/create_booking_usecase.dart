import '../entities/booking.dart';
import '../entities/passenger.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<BookingEntity> execute({
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
  }) {
    return repository.confirmBooking(
      tripId: tripId,
      userId: userId,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      boardingPoint: boardingPoint,
      droppingPoint: droppingPoint,
      seatIds: seatIds,
      passengers: passengers,
      paymentMethod: paymentMethod,
      baseFare: baseFare,
      convenienceFee: convenienceFee,
      totalAmount: totalAmount,
    );
  }
}
