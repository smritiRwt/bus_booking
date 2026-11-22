enum SeatStatus { available, selected, booked }

class SeatEntity {
  final int id;
  final int tripId;
  final String seatNumber; // e.g. "L1", "U1", "1A"
  final String seatType; // 'seater', 'sleeper'
  final String deck; // 'lower', 'upper'
  final int rowIndex;
  final int columnIndex;
  final double price;
  final bool isBooked;

  const SeatEntity({
    required this.id,
    required this.tripId,
    required this.seatNumber,
    required this.seatType,
    required this.deck,
    required this.rowIndex,
    required this.columnIndex,
    required this.price,
    required this.isBooked,
  });

  bool get isSleeper => seatType.toLowerCase() == 'sleeper';
  bool get isLowerDeck => deck.toLowerCase() == 'lower';

  SeatEntity copyWith({
    int? id,
    int? tripId,
    String? seatNumber,
    String? seatType,
    String? deck,
    int? rowIndex,
    int? columnIndex,
    double? price,
    bool? isBooked,
  }) {
    return SeatEntity(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      seatNumber: seatNumber ?? this.seatNumber,
      seatType: seatType ?? this.seatType,
      deck: deck ?? this.deck,
      rowIndex: rowIndex ?? this.rowIndex,
      columnIndex: columnIndex ?? this.columnIndex,
      price: price ?? this.price,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}
