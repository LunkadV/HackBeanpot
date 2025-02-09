import 'package:flutter/material.dart';

class RoadtripRemixPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roadtrip Remix'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // TODO: Implement "Get Custom Playlist" logic
                print('Get Custom Playlist button pressed');
              },
              child: Text('Get Custom Playlist'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement "Get Custom Personalized Playlist" logic
                print('Get Custom Personalized Playlist button pressed');
              },
              child: Text('Get Custom Personalized Playlist'),
            ),
          ],
        ),
      ),
    );
  }
}

