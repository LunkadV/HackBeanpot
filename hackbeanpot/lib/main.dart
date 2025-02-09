import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackbeanpot/pages/create_trip_page.dart';
import 'package:hackbeanpot/pages/home_page.dart';
import 'package:hackbeanpot/pages/profile_page.dart';
import 'Pages/auth_page.dart';
import 'firebase_options.dart';
import 'package:hackbeanpot/pages/spotify_remix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/create_trip': (context) => const CreateTripPage(),
      },
    );
  }
}
