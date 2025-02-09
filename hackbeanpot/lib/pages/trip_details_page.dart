import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripName;
  final String date;
  final String distance;
  final String stops;
  final String heroTag; // Add this field

  const TripDetailsPage({
    super.key,
    required this.tripName,
    required this.date,
    required this.distance,
    required this.stops,
    required this.heroTag, // Add this parameter
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
            final startPoint = GeoPoint(
              latitude: start.latitude.toDouble(),
              longitude: start.longitude.toDouble(),
            );
            final endPoint = GeoPoint(
              latitude: end.latitude.toDouble(),
              longitude: end.longitude.toDouble(),
            );

            // Draw the route
            final road = await _mapController.drawRoad(
              startPoint,
              endPoint,
              roadOption: const RoadOption(
                roadWidth: 10,
                roadColor: Colors.blue,
                zoomInto: true,
              ),
            );

            setState(() {
              _distance =
                  (road.distance ?? 0) / 1000; // Convert meters to kilometers
            });

            // Add markers for start and end points
            await _mapController.removeMarkers([startPoint, endPoint]);
            await _mapController.addMarker(
              startPoint,
              markerIcon: const MarkerIcon(
                icon: Icon(Icons.location_on, color: Colors.blue, size: 48),
              ),
            );
            await _mapController.addMarker(
              endPoint,
              markerIcon: const MarkerIcon(
                icon: Icon(Icons.flag, color: Colors.red, size: 48),
              ),
            );
          }
        }
      } catch (e) {
        print('Error calculating distance: $e');
        setState(() {
          _distance = 0.0;
        });
      }
    }
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: CupertinoColors.activeBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBackground,
        elevation: 0,
        leading: Hero(
          tag: 'back_button_${widget.tripName}', // Add unique hero tag
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.back,
              color: CupertinoColors.activeBlue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Hero(
          tag: widget.heroTag, // Use the passed tag
          child: Text(
            widget.tripName,
            style: const TextStyle(
              color: CupertinoColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: OSMFlutter(
                        controller: _mapController,
                        osmOption: OSMOption(
                          enableRotationByGesture: true,
                          zoomOption: const ZoomOption(
                            initZoom: 12,
                            minZoomLevel: 4,
                            maxZoomLevel: 18,
                          ),
                          userTrackingOption: const UserTrackingOption(
                            enableTracking: false,
                            unFollowUser: true,
                          ),
                          showZoomController: true,
                          staticPoints: [
                            StaticPositionGeoPoint(
                              "start_point",
                              MarkerIcon(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 56,
                                ),
                              ),
                              [
                                GeoPoint(latitude: 42.3601, longitude: -71.0589)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          onPressed: () => _mapController.zoomIn(),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          onPressed: () => _mapController.zoomOut(),
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildInfoCard(
                            'Date', widget.date, CupertinoIcons.calendar),
                        _buildInfoCard(
                          'Distance',
                          '${_distance.toStringAsFixed(1)} km',
                          CupertinoIcons.map,
                        ),
                        _buildInfoCard(
                            'Stops', widget.stops, CupertinoIcons.location),
                        _buildInfoCard(
                          'Duration',
                          '3 days',
                          CupertinoIcons.time,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Route Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildRoutePoint(
                              'Start', widget.tripName.split(' to ').first),
                          const SizedBox(height: 16),
                          _buildRoutePoint(
                              'End', widget.tripName.split(' to ').last),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Hero(
        tag:
            'trip_details_fab_${widget.heroTag}', // Add unique tag using trip identifier
        child: FloatingActionButton(
          onPressed: () {
            // Your FAB action here
          },
          child: const Icon(Icons.edit), // or whatever icon you're using
        ),
      ),
    );
  }

  Widget _buildRoutePoint(String type, String location) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: type == 'Start'
                ? CupertinoColors.activeGreen.withOpacity(0.1)
                : CupertinoColors.systemRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type == 'Start' ? CupertinoIcons.placemark : CupertinoIcons.flag,
            color: type == 'Start'
                ? CupertinoColors.activeGreen
                : CupertinoColors.systemRed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
