import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.sourceCity,
    required super.destinationCity,
    required super.distanceKm,
    required super.estimatedDuration,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      id: map['id'] as int,
      sourceCity: map['source_city'] as String,
      destinationCity: map['destination_city'] as String,
      distanceKm: (map['distance_km'] as num).toDouble(),
      estimatedDuration: map['estimated_duration'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source_city': sourceCity,
      'destination_city': destinationCity,
      'distance_km': distanceKm,
      'estimated_duration': estimatedDuration,
    };
  }

  factory RouteModel.fromEntity(RouteEntity entity) {
    return RouteModel(
      id: entity.id,
      sourceCity: entity.sourceCity,
      destinationCity: entity.destinationCity,
      distanceKm: entity.distanceKm,
      estimatedDuration: entity.estimatedDuration,
    );
  }
}
