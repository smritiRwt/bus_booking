import '../../domain/entities/booking.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/local_database_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final LocalDatabaseDataSource localDataSource;

  BookingRepositoryImpl(this.localDataSource);

  @override
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
  }) async {
    return await localDataSource.confirmBooking(
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

  @override
  Future<bool> cancelBooking({
    required int bookingId,
    required String reason,
  }) async {
    return await localDataSource.cancelBooking(
      bookingId: bookingId,
      reason: reason,
    );
  }

  @override
  Future<BookingEntity?> getBookingById(int bookingId) async {
    return await localDataSource.getBookingById(bookingId);
  }

  @override
  Future<BookingEntity?> getBookingByPnr(String pnr) async {
    return await localDataSource.getBookingByPnr(pnr);
  }

  @override
  Future<List<BookingEntity>> getUserBookings(int userId) async {
    return await localDataSource.getUserBookings(userId);
  }

  @override
  Future<BookingEntity?> getUpcomingBooking(int userId) async {
    return await localDataSource.getUpcomingBooking(userId);
  }
}
