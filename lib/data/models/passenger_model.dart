import '../../domain/entities/passenger.dart';

class PassengerModel extends PassengerEntity {
  const PassengerModel({
    super.id,
    super.bookingId,
    required super.fullName,
    required super.age,
    required super.gender,
    required super.seatNumber,
  });

  factory PassengerModel.fromMap(Map<String, dynamic> map) {
    return PassengerModel(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int?,
      fullName: map['full_name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      seatNumber: map['seat_number'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'seat_number': seatNumber,
    };
    if (id != null) map['id'] = id;
    if (bookingId != null) map['booking_id'] = bookingId;
    return map;
  }

  factory PassengerModel.fromEntity(PassengerEntity entity) {
    return PassengerModel(
      id: entity.id,
      bookingId: entity.bookingId,
      fullName: entity.fullName,
      age: entity.age,
      gender: entity.gender,
      seatNumber: entity.seatNumber,
    );
  }
}
