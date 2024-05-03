import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'admin.dart';
import 'client.dart';
import 'logout.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = _fetchDashboardData();
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    try {
      final response = await http
          .get(Uri.parse('https://anasorchy.000webhostapp.com/get.php'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (error) {
      debugPrint('Error fetching dashboard data: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'JOOR Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Show Admins'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Show Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LogoutPage()), // Navigate to LogoutPage
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Dashboard',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Widgets for displaying statistics (order count, user count, profit, etc.)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatisticWidget(
                          icon: Icons.calendar_today,
                          value: data['totalOrders'].toString(),
                          label: 'New Orders',
                        ),
                        StatisticWidget(
                          icon: Icons.group,
                          value: data['totalUsers'].toString(),
                          label: 'Visitors',
                        ),
                        StatisticWidget(
                          icon: Icons.attach_money,
                          value: data['totalProfit'].toString(),
                          label: 'Total Profit',
                        ),
                      ],
                    ),
                  ),
                  // Widget for displaying recent orders
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recent Orders',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Loop through recent orders and display each one
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data['recentOrders'].length,
                    itemBuilder: (context, index) {
                      final order = data['recentOrders'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: OrderItemWidget(
                          orderId: order['order_id'].toString(),
                          customerName: order['customer_name'],
                          customerEmail: order['customer_email'],
                          date: order['order_date'],
                          price: order['price'].toString(),
                        ),
                      );
                    },
                  ),
                  // Add other widgets as needed
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class StatisticWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatisticWidget(
      {Key? key, required this.icon, required this.value, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String date;
  final String price;

  const OrderItemWidget(
      {Key? key,
      required this.orderId,
      required this.customerName,
      required this.customerEmail,
      required this.date,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text('Order ID: $orderId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: $customerName'),
            Text('Customer Email: $customerEmail'),
            Text('Date: $date'),
            Text('Price: $price'),
          ],
        ),
      ),
    );
  }
}
