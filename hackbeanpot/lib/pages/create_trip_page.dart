// create_trip_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  // Add search results state
  List<SearchInfo> _startSearchResults = [];
  List<SearchInfo> _endSearchResults = [];

  DateTime? _startDate;
  DateTime? _endDate;
  late MapController _mapController;
  GeoPoint? _startLocation;
  GeoPoint? _endLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
          latitude: 42.3601, longitude: -71.0589), // Boston coordinates
      areaLimit: BoundingBox(
        north: 85,
        south: -85,
        east: 180,
        west: -180,
      ),
    );
  }

  @override
  void dispose() {
    _startLocationController.dispose();
    _endLocationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _searchLocations(String query, bool isStart) async {
    if (query.length < 3) return;

    try {
      final results = await addressSuggestion(query);
      setState(() {
        if (isStart) {
          _startSearchResults = results;
        } else {
          _endSearchResults = results;
        }
      });
    } catch (e) {
      print('Error searching locations: $e');
    }
  }

  Future<void> _selectLocation(SearchInfo info, bool isStart) async {
    // Add null checks for point properties
    if (info.point?.latitude == null || info.point?.longitude == null) {
      _showError('Invalid location coordinates received');
      return;
    }

    final point = GeoPoint(
        latitude: info.point!.latitude, longitude: info.point!.longitude);

    setState(() {
      if (isStart) {
        _startLocationController.text =
            info.address?.toString() ?? 'Unknown location';
        _startLocation = point;
        _startSearchResults = [];
      } else {
        _endLocationController.text =
            info.address?.toString() ?? 'Unknown location';
        _endLocation = point;
        _endSearchResults = [];
      }
    });

    await _updateMapMarkers();
  }

  Future<void> _updateMapMarkers() async {
    await _mapController.clearAllRoads();

    if (_startLocation != null) {
      await _mapController.addMarker(
        _startLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 48),
        ),
      );
    }

    if (_endLocation != null) {
      await _mapController.addMarker(
        _endLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.flag, color: Colors.red, size: 48),
        ),
      );

      if (_startLocation != null) {
        await _getRoute();
      }
    }
  }

  Future<void> _getRoute() async {
    if (_startLocation == null || _endLocation == null) return;

    try {
      await _mapController.drawRoad(
        _startLocation!,
        _endLocation!,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: Colors.blue,
          zoomInto: true,
        ),
      );
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  // Add this method to show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
        actions: [
          TextButton(
            onPressed: () {
              if (_startLocation != null && _endLocation != null) {
                Navigator.pop(context, {
                  'start': _startLocationController.text,
                  'end': _endLocationController.text,
                });
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Start Location'),
            const SizedBox(height: 8),
            _buildLocationField(
              'Enter start location',
              _startLocationController,
              _startSearchResults,
              true,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('End Location'),
            const SizedBox(height: 8),
            _buildLocationField(
              'Enter end location',
              _endLocationController,
              _endSearchResults,
              false,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Dates'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'Start Date',
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    'End Date',
                    _endDate,
                    (date) => setState(() => _endDate = date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Route'),
            const SizedBox(height: 8),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OSMFlutter(
                  controller: _mapController,
                  onMapIsReady: (isReady) {
                    if (isReady) {
                      print("Map is ready");
                    }
                  },
                  osmOption: OSMOption(
                    zoomOption: const ZoomOption(
                      initZoom: 2,
                      minZoomLevel: 2,
                      maxZoomLevel: 18,
                      stepZoom: 1.0,
                    ),
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: false,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(Icons.location_on,
                            color: Colors.blue, size: 48),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(Icons.double_arrow, size: 48),
                      ),
                    ),
                    roadConfiguration: const RoadOption(
                      roadColor: Colors.blue,
                      roadWidth: 10,
                      zoomInto: true,
                    ),
                    staticPoints: [
                      StaticPositionGeoPoint(
                        "markers",
                        const MarkerIcon(
                          icon: Icon(Icons.location_on,
                              color: Colors.red, size: 48),
                        ),
                        [], // Initial list of markers is empty
                      ),
                    ],
                  ),
                  onGeoPointClicked: (point) async {
                    if (_startLocation == null) {
                      setState(() {
                        _startLocation = point;
                      });
                      await _mapController.addMarker(
                        point,
                        markerIcon: const MarkerIcon(
                          icon: Icon(Icons.location_on,
                              color: Colors.blue, size: 48),
                        ),
                      );
                    } else if (_endLocation == null) {
                      setState(() {
                        _endLocation = point;
                      });
                      await _mapController.addMarker(
                        point,
                        markerIcon: const MarkerIcon(
                          icon: Icon(Icons.flag, color: Colors.red, size: 48),
                        ),
                      );
                      await _getRoute();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Trip Type'),
            const SizedBox(height: 8),
            _buildTripTypeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onSelect,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          onSelect(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : 'Select date',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeGrid() {
    final tripTypes = [
      {'icon': Icons.beach_access, 'label': 'Beach'},
      {'icon': Icons.landscape, 'label': 'Mountain'},
      {'icon': Icons.location_city, 'label': 'City'},
      {'icon': Icons.forest, 'label': 'Nature'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tripTypes.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tripTypes[index]['icon'] as IconData,
                size: 32,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                tripTypes[index]['label'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationField(
    String label,
    TextEditingController controller,
    List<SearchInfo> searchResults,
    bool isStart,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) => _searchLocations(value, isStart),
        ),
        if (searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index].address?.toString() ??
                      'Unknown address'),
                  onTap: () => _selectLocation(searchResults[index], isStart),
                );
              },
            ),
          ),
      ],
    );
  }
}
