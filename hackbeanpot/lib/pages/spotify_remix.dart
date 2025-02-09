import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackbeanpot/models/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/spotify_service.dart';

class RoadtripRemixPage extends StatefulWidget {
  const RoadtripRemixPage({Key? key}) : super(key: key);

  @override
  State<RoadtripRemixPage> createState() => _RoadtripRemixPageState();
}

class _RoadtripRemixPageState extends State<RoadtripRemixPage> {
  final SpotifyService _spotifyService = SpotifyService();
  bool _isLoading = false;
  String _currentLocationType = 'unknown';

  @override
  void initState() {
    super.initState();
    _determineLocation();
  }

  Future<void> _determineLocation() async {
    setState(() => _isLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        // Simple logic to determine location type
        final placemark = placemarks.first;
        if (placemark.locality?.isNotEmpty ?? false) {
          _currentLocationType = 'city';
        } else if (placemark.administrativeArea?.isNotEmpty ?? false) {
          _currentLocationType = 'rural';
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadtrip Remix'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPlaylistOption(
                        icon: Icons.location_on,
                        title: 'Location-Based Mix',
                        subtitle:
                            'Create a playlist based on your surroundings',
                        onTap: () async {
                          try {
                            await _spotifyService.createLocationBasedPlaylist(
                              'Current Location',
                              _currentLocationType,
                            );
                            _showSuccessMessage(
                                'Location-based playlist created!');
                          } catch (e) {
                            _showErrorMessage(e.toString());
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPlaylistOption(
                        icon: Icons.person,
                        title: 'Personalized Mix',
                        subtitle: 'Create a playlist based on your music taste',
                        onTap: () async {
                          try {
                            await _spotifyService.createPersonalizedPlaylist();
                            _showSuccessMessage(
                                'Personalized playlist created!');
                          } catch (e) {
                            _showErrorMessage(e.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPlaylistOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
