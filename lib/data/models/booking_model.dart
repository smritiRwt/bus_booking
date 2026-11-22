import '../../domain/entities/booking.dart';
import '../../domain/entities/passenger.dart';
import 'trip_model.dart';

class BookingSeatModel extends BookingSeatEntity {
  const BookingSeatModel({
    super.id,
    super.bookingId,
    required super.seatId,
    required super.seatNumber,
    required super.seatPrice,
  });

  factory BookingSeatModel.fromMap(Map<String, dynamic> map) {
    return BookingSeatModel(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int?,
      seatId: map['seat_id'] as int,
      seatNumber: map['seat_number'] as String,
      seatPrice: (map['seat_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'seat_id': seatId,
      'seat_number': seatNumber,
      'seat_price': seatPrice,
    };
    if (id != null) map['id'] = id;
    if (bookingId != null) map['booking_id'] = bookingId;
    return map;
  }
}

class BookingModel extends BookingEntity {
  const BookingModel({
    super.id,
    required super.pnr,
    required super.tripId,
    required super.userId,
    required super.contactEmail,
    required super.contactPhone,
    required super.totalPassengers,
    required super.baseFare,
    required super.convenienceFee,
    required super.totalAmount,
    required super.bookingStatus,
    required super.bookingDate,
    required super.boardingPoint,
    required super.droppingPoint,
    super.cancellationReason,
    super.cancelledAt,
    super.trip,
    super.passengers,
    super.bookingSeats,
  });

  factory BookingModel.fromMap(
    Map<String, dynamic> map, {
    TripModel? trip,
    List<PassengerEntity>? passengers,
    List<BookingSeatEntity>? bookingSeats,
  }) {
    return BookingModel(
      id: map['id'] as int?,
      pnr: map['pnr'] as String,
      tripId: map['trip_id'] as int,
      userId: map['user_id'] as int,
      contactEmail: map['contact_email'] as String,
      contactPhone: map['contact_phone'] as String,
      totalPassengers: map['total_passengers'] as int,
      baseFare: (map['base_fare'] as num).toDouble(),
      convenienceFee: (map['convenience_fee'] as num).toDouble(),
      totalAmount: (map['total_amount'] as num).toDouble(),
      bookingStatus: map['booking_status'] as String,
      bookingDate: map['booking_date'] as String,
      boardingPoint: map['boarding_point'] as String,
      droppingPoint: map['dropping_point'] as String,
      cancellationReason: map['cancellation_reason'] as String?,
      cancelledAt: map['cancelled_at'] as String?,
      trip: trip,
      passengers: passengers ?? [],
      bookingSeats: bookingSeats ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'pnr': pnr,
      'trip_id': tripId,
      'user_id': userId,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'total_passengers': totalPassengers,
      'base_fare': baseFare,
      'convenience_fee': convenienceFee,
      'total_amount': totalAmount,
      'booking_status': bookingStatus,
      'booking_date': bookingDate,
      'boarding_point': boardingPoint,
      'dropping_point': droppingPoint,
      'cancellation_reason': cancellationReason,
      'cancelled_at': cancelledAt,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
