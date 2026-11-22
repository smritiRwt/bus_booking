import 'bus.dart';
import 'route_entity.dart';

class BoardingDroppingPoint {
  final String pointName;
  final String time;
  final String landmark;

  const BoardingDroppingPoint({
    required this.pointName,
    required this.time,
    required this.landmark,
  });

  factory BoardingDroppingPoint.fromJson(Map<String, dynamic> json) {
    return BoardingDroppingPoint(
      pointName: json['pointName'] as String? ?? json['name'] as String? ?? '',
      time: json['time'] as String? ?? '',
      landmark: json['landmark'] as String? ?? json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'pointName': pointName,
    'time': time,
    'landmark': landmark,
  };
}

class TripEntity {
  final int id;
  final int busId;
  final int routeId;
  final String journeyDate; // YYYY-MM-DD
  final String departureTime;
  final String arrivalTime;
  final double basePrice;
  final List<BoardingDroppingPoint> boardingPoints;
  final List<BoardingDroppingPoint> droppingPoints;
  final int availableSeatsCount;

  // Joined fields for display
  final BusEntity? bus;
  final RouteEntity? route;

  const TripEntity({
    required this.id,
    required this.busId,
    required this.routeId,
    required this.journeyDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.basePrice,
    required this.boardingPoints,
    required this.droppingPoints,
    required this.availableSeatsCount,
    this.bus,
    this.route,
  });
}
