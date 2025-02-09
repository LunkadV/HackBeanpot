import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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
            // Calculate distance here
          }
        }
      } catch (e) {
        print('Error calculating distance: $e');
      }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Trip Name: ${widget.tripName}'),
            Text('Date: ${widget.date}'),
            Text('Distance: ${widget.distance}'),
            Text('Stops: ${widget.stops}'),
          ],
        ),
      ),
    );
  }
}
