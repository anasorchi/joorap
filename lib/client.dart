import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Client {
  final String username;
  final String email;

  Client({
    required this.username,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      username: json['username'],
      email: json['email'],
    );
  }
}

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<Client> clients = [];
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('https://anasorchy.000webhostapp.com/clients.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          clients =
              data.map((clientJson) => Client.fromJson(clientJson)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load clients: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients Page'),
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
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blue,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          clients[index].username,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          clients[index].email,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
