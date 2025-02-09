// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/road_trip.dart';

Future<RoadTrip> buildRoadTrip(String start, String end) async {
  // For local testing on an emulator or simulator, "localhost" generally works.
  // If testing on a physical device, use your computer's IP address.
  final url = Uri.parse('http://localhost:3000/roadtrip');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "start": start,
      "end": end,
    }),
  );

  if (response.statusCode == 200) {
    return RoadTrip.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to build road trip: ${response.statusCode}");
  }
}