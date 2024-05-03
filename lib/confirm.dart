import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ConfirmPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  ConfirmPage({required this.productData});

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  Uint8List? _imageBytes;

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(bytes);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(bytes);
      });
    }
  }

  Future<void> _submitProduct(BuildContext context) async {
    // Check if any required field is missing
    if (widget.productData['name'] == null ||
        widget.productData['price'] == null ||
        widget.productData['description'] == null ||
        widget.productData['originalPrice'] == null ||
        widget.productData['quantity'] == null ||
        widget.productData['category'] == null ||
        _imageBytes == null) {
      // Show error message if any required field is missing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('All fields are required.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    var url = Uri.parse('https://anasorchy.000webhostapp.com/insert.php');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          _imageBytes!,
          filename: 'product_image.jpg',
        ),
      );

      // Add other product data to the request
      request.fields['name'] = widget.productData['name'];
      request.fields['price'] = widget.productData['price'].toString();
      request.fields['description'] = widget.productData['description'];
      request.fields['originalPrice'] =
          widget.productData['originalPrice'].toString();
      request.fields['quantity'] = widget.productData['quantity'].toString();
      request.fields['category'] = widget.productData['category'];

      var response = await request.send();

      if (response.statusCode == 200) {
        // Show success alert
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Product inserted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pop(context); // Navigate back to previous page
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        // DEBUGGING: Print the response from the API
        print(await response.stream.bytesToString());

        // DEBUGGING: Check the database manually to ensure product insertion
      } else {
        print(
            'Failed to submit product data. Status code: ${response.statusCode}');
        // Handle error response
      }
    } catch (error) {
      print('Error submitting product data: $error');
      // Handle any network or server errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_imageBytes != null)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Image.memory(
                    _imageBytes!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _getImageFromCamera,
                    icon: Icon(Icons.camera),
                    label: Text('Camera'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _getImageFromGallery,
                    icon: Icon(Icons.image),
                    label: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Product Name: ${widget.productData['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Price: \$${widget.productData['price']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${widget.productData['description']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Original Price: \$${widget.productData['originalPrice']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Quantity: ${widget.productData['quantity']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Category: ${widget.productData['category']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitProduct(context); // Submit product data to API
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
