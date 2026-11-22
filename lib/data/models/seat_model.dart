import '../../domain/entities/seat.dart';

class SeatModel extends SeatEntity {
  const SeatModel({
    required super.id,
    required super.tripId,
    required super.seatNumber,
    required super.seatType,
    required super.deck,
    required super.rowIndex,
    required super.columnIndex,
    required super.price,
    required super.isBooked,
  });

  factory SeatModel.fromMap(Map<String, dynamic> map) {
    return SeatModel(
      id: map['id'] as int,
      tripId: map['trip_id'] as int,
      seatNumber: map['seat_number'] as String,
      seatType: map['seat_type'] as String,
      deck: map['deck'] as String,
      rowIndex: map['row_index'] as int,
      columnIndex: map['column_index'] as int,
      price: (map['price'] as num).toDouble(),
      isBooked: (map['is_booked'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'seat_number': seatNumber,
      'seat_type': seatType,
      'deck': deck,
      'row_index': rowIndex,
      'column_index': columnIndex,
      'price': price,
      'is_booked': isBooked ? 1 : 0,
    };
  }

  factory SeatModel.fromEntity(SeatEntity entity) {
    return SeatModel(
      id: entity.id,
      tripId: entity.tripId,
      seatNumber: entity.seatNumber,
      seatType: entity.seatType,
      deck: entity.deck,
      rowIndex: entity.rowIndex,
      columnIndex: entity.columnIndex,
      price: entity.price,
      isBooked: entity.isBooked,
    );
  }
}
