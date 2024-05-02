import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addproduct.dart'; // Import AddProductPage here

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://anasorchy.000webhostapp.com/get.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productList = data['products'];
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
            child: Text('Add Product'),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: Text(
                            product.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${product.id}',
                                  style: TextStyle(color: Colors.white)),
                              Text('Price: ${product.price}',
                                  style: TextStyle(color: Colors.white)),
                              Text('Profit: ${product.profit}',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          onTap: () {
                            // Handle tapping on a product item
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String price;
  final String profit;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.profit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: json['price'].toString(),
      profit: json['profit'].toString(),
    );
  }
}
