class RouteEntity {
  final int id;
  final String sourceCity;
  final String destinationCity;
  final double distanceKm;
  final String estimatedDuration;

  const RouteEntity({
    required this.id,
    required this.sourceCity,
    required this.destinationCity,
    required this.distanceKm,
    required this.estimatedDuration,
  });
}
