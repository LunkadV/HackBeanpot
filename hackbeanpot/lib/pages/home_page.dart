import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_or_register_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginOrRegisterPage()),
            );
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
