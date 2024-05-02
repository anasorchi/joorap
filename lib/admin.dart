import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Admin {
  final String username;
  final String email;

  Admin({
    required this.username,
    required this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      username: json['username'],
      email: json['email'],
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Admin> admins = [];
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  Future<void> fetchAdmins() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('https://anasorchy.000webhostapp.com/admins.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          admins = data.map((adminJson) => Admin.fromJson(adminJson)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load admins');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load admins: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : error.isNotEmpty
              ? Center(
                  child: Text(error),
                )
              : ListView.builder(
                  itemCount: admins.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blue,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          admins[index].username,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          admins[index].email,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
