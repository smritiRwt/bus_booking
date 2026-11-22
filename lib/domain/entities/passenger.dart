class PassengerEntity {
  final int? id;
  final int? bookingId;
  final String fullName;
  final int age;
  final String gender; // 'Male', 'Female', 'Other'
  final String seatNumber;

  const PassengerEntity({
    this.id,
    this.bookingId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.seatNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'booking_id': bookingId,
    'full_name': fullName,
    'age': age,
    'gender': gender,
    'seat_number': seatNumber,
  };
}
