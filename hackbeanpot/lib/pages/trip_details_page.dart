import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripName;
  final String date;
  final String distance;
  final String stops;

  const TripDetailsPage({
    super.key,
    required this.tripName,
    required this.date,
    required this.distance,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBackground,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          tripName,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add trip details UI here
          ],
        ),
      ),
    );
  }
}
