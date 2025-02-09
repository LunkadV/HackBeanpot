// home_page.dart
import 'package:flutter/material.dart';
import 'package:hackbeanpot/models/trip.dart';
import 'package:hackbeanpot/pages/spotify_remix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _storageKey = 'trips';
  List<Trip> _trips = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsString = prefs.getString(_storageKey);
    if (tripsString != null) {
      final List<dynamic> tripsJson = jsonDecode(tripsString);
      setState(() {
        _trips = tripsJson.map((json) => Trip.fromJson(json)).toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTripImage(int index) {
    // Cycle through available trip images
    final imageIndex = (index % 3) + 1; // We have 3 trip images
    return 'lib/images/trip_$imageIndex.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildMainContent(),
          const RoadtripRemixPage(), // Add the music page
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note), // Add music icon
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _buildTripsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Trips',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create_trip');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search destinations',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {},
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsGrid() {
    if (_trips.isEmpty) {
      return Center(
        child: Text(
          'No trips yet. Create one by tapping the + button!',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _trips.length,
      itemBuilder: (context, index) {
        final trip = _trips[index];
        final heroTag =
            'trip_${index}_${trip.startLocation}_${trip.endLocation}';

        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/trip_details',
              arguments: {
                'tripName': '${trip.startLocation} to ${trip.endLocation}',
                'date':
                    '${trip.startDate.day}-${trip.endDate.day} ${trip.startDate.month}',
                'distance': '0',
                'stops': '2',
                'heroTag': heroTag,
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: AssetImage(_getTripImage(index)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: heroTag,
                          child: Text(
                            trip.endLocation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${trip.startDate.day}-${trip.endDate.day} ${trip.startDate.month}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
