class BusEntity {
  final int id;
  final String name;
  final String operatorName;
  final String busType; // 'AC Sleeper', 'Non-AC Sleeper', 'AC Seater', 'Non-AC Seater'
  final int totalSeats;
  final double rating;
  final List<String> amenities;
  final String cancellationPolicy;

  const BusEntity({
    required this.id,
    required this.name,
    required this.operatorName,
    required this.busType,
    required this.totalSeats,
    required this.rating,
    required this.amenities,
    required this.cancellationPolicy,
  });

  bool get isAc => busType.toLowerCase().contains('ac') && !busType.toLowerCase().contains('non-ac');
  bool get isSleeper => busType.toLowerCase().contains('sleeper');
}
