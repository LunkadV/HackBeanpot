// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/road_trip.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  RoadTrip? roadTrip;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _submit() async {
    final start = startController.text.trim();
    final end = endController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter both a start and end location."))
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await buildRoadTrip(start, end);
      setState(() {
        roadTrip = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Road Trip Builder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: startController,
              decoration: const InputDecoration(
                labelText: "Start Location (A)",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: endController,
              decoration: const InputDecoration(
                labelText: "End Location (B)",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Build Road Trip"),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator(),
            if (roadTrip != null)
              Card(
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start: ${roadTrip!.start}"),
                      Text("End: ${roadTrip!.end}"),
                      const SizedBox(height: 8),
                      Text(
                        roadTrip!.route,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}