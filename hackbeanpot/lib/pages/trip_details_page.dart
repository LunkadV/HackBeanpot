import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:math';

class TripDetailsPage extends StatefulWidget {
  final String tripName;
  final String date;
  final String distance;
  final String stops;
  final String heroTag;

  const TripDetailsPage({
    super.key,
    required this.tripName,
    required this.date,
    required this.distance,
    required this.stops,
    required this.heroTag,
  });

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late MapController _mapController;
  double _distance = 0.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: 42.3601,
        longitude: -71.0589,
      ),
      areaLimit: const BoundingBox(
        north: 85,
        south: -85,
        east: 180,
        west: -180,
      ),
    );
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    final points = widget.tripName.split(' to ');
    if (points.length == 2) {
      try {
        final startResults = await addressSuggestion(points[0]);
        final endResults = await addressSuggestion(points[1]);

        if (startResults.isNotEmpty && endResults.isNotEmpty) {
          final start = startResults.first.point;
          final end = endResults.first.point;

          if (start != null && end != null) {
            await _createRoute(start, end);
          }
        }
      } catch (e) {
        print('Error calculating distance: $e');
      }
    }
  }

  Future<void> _createRoute(GeoPoint start, GeoPoint end) async {
    try {
      // Clear existing markers and roads
      await _mapController.clearAllRoads();

      // Add start marker
      await _mapController.addMarker(
        start,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.trip_origin, color: Colors.blue, size: 32),
        ),
      );

      // Add end marker
      await _mapController.addMarker(
        end,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.place, color: Colors.red, size: 32),
        ),
      );

      // Draw the route
      final roadInfo = await _mapController.drawRoad(
        start,
        end,
        roadOption: const RoadOption(
          roadWidth: 5,
          roadColor: Colors.blue,
          zoomInto: true,
        ),
      );

      // Zoom to show the entire route
      await _mapController.zoomToBoundingBox(
        BoundingBox(
          north: max(start.latitude, end.latitude) + 0.1,
          south: min(start.latitude, end.latitude) - 0.1,
          east: max(start.longitude, end.longitude) + 0.1,
          west: min(start.longitude, end.longitude) - 0.1,
        ),
        paddinInPixel: 64,
      );

      // Update distance if available
      setState(() {
        _distance = roadInfo.distance!;
      });
    } catch (e) {
      print('Error creating route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.heroTag,
          child: Text(widget.tripName),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: OSMFlutter(
              controller: _mapController,
              onMapIsReady: (isReady) {
                if (isReady) {
                  _calculateDistance();
                }
              },
              osmOption: const OSMOption(
                zoomOption: ZoomOption(
                  initZoom: 12,
                  minZoomLevel: 4,
                  maxZoomLevel: 18,
                  stepZoom: 1.0,
                ),
                userTrackingOption: UserTrackingOption(
                  enableTracking: false,
                  unFollowUser: true,
                ),
                roadConfiguration: RoadOption(
                  roadColor: Colors.blue,
                  roadWidth: 5,
                  zoomInto: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Trip Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trip Name: ${widget.tripName}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${widget.date}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Distance: ${_distance.toStringAsFixed(2)} km',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stops: ${widget.stops}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
