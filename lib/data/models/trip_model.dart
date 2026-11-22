import 'dart:convert';
import '../../domain/entities/trip.dart';
import 'bus_model.dart';
import 'route_model.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.busId,
    required super.routeId,
    required super.journeyDate,
    required super.departureTime,
    required super.arrivalTime,
    required super.basePrice,
    required super.boardingPoints,
    required super.droppingPoints,
    required super.availableSeatsCount,
    super.bus,
    super.route,
  });

  factory TripModel.fromMap(
    Map<String, dynamic> map, {
    BusModel? bus,
    RouteModel? route,
  }) {
    List<BoardingDroppingPoint> parsePoints(dynamic raw) {
      if (raw == null) return [];
      try {
        if (raw is String) {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            return decoded
                .map((e) => BoardingDroppingPoint.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      } catch (_) {}
      return [];
    }

    return TripModel(
      id: map['id'] as int,
      busId: map['bus_id'] as int,
      routeId: map['route_id'] as int,
      journeyDate: map['journey_date'] as String,
      departureTime: map['departure_time'] as String,
      arrivalTime: map['arrival_time'] as String,
      basePrice: (map['base_price'] as num).toDouble(),
      boardingPoints: parsePoints(map['boarding_points']),
      droppingPoints: parsePoints(map['dropping_points']),
      availableSeatsCount: map['available_seats_count'] as int,
      bus: bus,
      route: route,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bus_id': busId,
      'route_id': routeId,
      'journey_date': journeyDate,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'base_price': basePrice,
      'boarding_points': jsonEncode(boardingPoints.map((e) => e.toJson()).toList()),
      'dropping_points': jsonEncode(droppingPoints.map((e) => e.toJson()).toList()),
      'available_seats_count': availableSeatsCount,
    };
  }
}
