import 'dart:convert';
import '../../domain/entities/bus.dart';

class BusModel extends BusEntity {
  const BusModel({
    required super.id,
    required super.name,
    required super.operatorName,
    required super.busType,
    required super.totalSeats,
    required super.rating,
    required super.amenities,
    required super.cancellationPolicy,
  });

  static List<String> parseAmenities(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    }
    return [];
  }

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      id: (map['id'] as int?) ?? 0,
      name: (map['name'] as String?) ?? '',
      operatorName: (map['operator_name'] as String?) ?? '',
      busType: (map['bus_type'] as String?) ?? '',
      totalSeats: (map['total_seats'] as int?) ?? 0,
      rating: ((map['rating'] as num?) ?? 4.0).toDouble(),
      amenities: parseAmenities(map['amenities']),
      cancellationPolicy: (map['cancellation_policy'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'operator_name': operatorName,
      'bus_type': busType,
      'total_seats': totalSeats,
      'rating': rating,
      'amenities': jsonEncode(amenities),
      'cancellation_policy': cancellationPolicy,
    };
  }

  factory BusModel.fromEntity(BusEntity entity) {
    return BusModel(
      id: entity.id,
      name: entity.name,
      operatorName: entity.operatorName,
      busType: entity.busType,
      totalSeats: entity.totalSeats,
      rating: entity.rating,
      amenities: entity.amenities,
      cancellationPolicy: entity.cancellationPolicy,
    );
  }
}
