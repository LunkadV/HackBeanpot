import 'dart:convert';

class Trip {
  final String startLocation;
  final String endLocation;
  final DateTime startDate;
  final DateTime endDate;

  Trip({
    required this.startLocation,
    required this.endLocation,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
