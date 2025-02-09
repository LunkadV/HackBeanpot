// lib/models/road_trip.dart
class RoadTrip {
  final String start;
  final String end;
  final String route;

  RoadTrip({
    required this.start,
    required this.end,
    required this.route,
  });

  factory RoadTrip.fromJson(Map<String, dynamic> json) {
    return RoadTrip(
      start: json["start"],
      end: json["end"],
      route: json["route"],
    );
  }
}