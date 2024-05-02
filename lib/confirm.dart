import 'package:flutter/material.dart';

class ConfirmPage extends StatelessWidget {
  final Map<String, dynamic> productData;

  ConfirmPage({required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Product'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product Name: ${productData['name']}'),
            Text('Price: ${productData['price']}'),
            Text('Profit: ${productData['profit']}'),
            Text('Description: ${productData['description']}'),
            Text('Original Price: ${productData['originalPrice']}'),
            Text('Quantity: ${productData['quantity']}'),
            Text('Category: ${productData['category']}'),
            ElevatedButton(
              onPressed: () {
                // Handle confirm logic here
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
