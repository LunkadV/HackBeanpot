import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackbeanpot/models/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadtripRemixPage extends StatelessWidget {
  // Add Spotify API integration
  final _spotifyApi = SpotifyApi();

  Future<void> _createCustomPlaylist(BuildContext context) async {
    try {
      // Get current user's trips from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final tripsString = prefs.getString('trips');
      if (tripsString != null) {
        final List<dynamic> tripsJson = jsonDecode(tripsString);
        final trips = tripsJson.map((json) => Trip.fromJson(json)).toList();

        if (trips.isNotEmpty) {
          // Get most recent trip
          final latestTrip = trips.last;

          // Generate playlist based on trip destination
          final playlist = await _spotifyApi.createPlaylist(
            name: '${latestTrip.endLocation} Trip Mix',
            description:
                'Custom playlist for your trip to ${latestTrip.endLocation}',
            // Add relevant genres/mood based on trip type
            seeds: ['road_trip', 'travel'],
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Playlist created successfully!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating playlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadtrip Remix'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _createCustomPlaylist(context),
              child: const Text('Get Custom Playlist'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Create personalized playlist with user preferences
                try {
                  await _spotifyApi.createPersonalizedPlaylist(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Personalized playlist created!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error creating playlist')),
                  );
                }
              },
              child: const Text('Get Custom Personalized Playlist'),
            ),
          ],
        ),
      ),
    );
  }
}

class SpotifyApi {
  Future<void> createPlaylist({
    required String name,
    required String description,
    required List<String> seeds,
  }) async {
    // Implement Spotify API calls here
    // 1. Authenticate with Spotify
    // 2. Create a new playlist
    // 3. Add tracks based on seeds (genre, mood, etc.)
  }

  Future<void> createPersonalizedPlaylist(BuildContext context) async {
    // Create playlist with user's Spotify preferences
    // 1. Get user's top tracks/artists
    // 2. Create playlist with similar music
  }
}
