import 'trip.dart';
import 'passenger.dart';

class BookingSeatEntity {
  final int? id;
  final int? bookingId;
  final int seatId;
  final String seatNumber;
  final double seatPrice;

  const BookingSeatEntity({
    this.id,
    this.bookingId,
    required this.seatId,
    required this.seatNumber,
    required this.seatPrice,
  });
}

class BookingEntity {
  final int? id;
  final String pnr;
  final int tripId;
  final int userId;
  final String contactEmail;
  final String contactPhone;
  final int totalPassengers;
  final double baseFare;
  final double convenienceFee;
  final double totalAmount;
  final String bookingStatus; // 'CONFIRMED', 'CANCELLED', 'COMPLETED'
  final String bookingDate; // DateTime string
  final String boardingPoint;
  final String droppingPoint;
  final String? cancellationReason;
  final String? cancelledAt;

  // Joined details
  final TripEntity? trip;
  final List<PassengerEntity> passengers;
  final List<BookingSeatEntity> bookingSeats;

  const BookingEntity({
    this.id,
    required this.pnr,
    required this.tripId,
    required this.userId,
    required this.contactEmail,
    required this.contactPhone,
    required this.totalPassengers,
    required this.baseFare,
    required this.convenienceFee,
    required this.totalAmount,
    required this.bookingStatus,
    required this.bookingDate,
    required this.boardingPoint,
    required this.droppingPoint,
    this.cancellationReason,
    this.cancelledAt,
    this.trip,
    this.passengers = const [],
    this.bookingSeats = const [],
  });

  bool get isConfirmed => bookingStatus == 'CONFIRMED';
  bool get isCancelled => bookingStatus == 'CANCELLED';
  bool get isCompleted => bookingStatus == 'COMPLETED';

  bool get canBeCancelled {
    if (!isConfirmed) return false;
    // Check if trip journey date and time is in future or today
    if (trip != null) {
      try {
        final date = DateTime.parse(trip!.journeyDate);
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);
        return date.isAfter(todayMidnight) || date.isAtSameMomentAs(todayMidnight);
      } catch (_) {
        return true;
      }
    }
    return true;
  }
}
