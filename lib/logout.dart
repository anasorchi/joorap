import 'package:flutter/material.dart';
import 'main.dart'; // Import the login page to navigate back to it

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the login page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false, // Remove all routes until this one
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
