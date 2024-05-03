import 'package:flutter/material.dart';
import 'dashboard.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Hardcoded email and password for demonstration
    const String hardcodedEmail = 'anasorchi2@gmail.com';
    const String hardcodedPassword = '1';

    if (email == hardcodedEmail && password == hardcodedPassword) {
      // Login successful, navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      // Login failed, display error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Login Failed',
            style: TextStyle(color: Colors.black), // Change text color to black
          ),
          content: Text(
            'Invalid email or password.',
            style: TextStyle(color: Colors.black), // Change text color to black
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(
                    color: Colors.black), // Change text color to black
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                // Use ClipOval to display circular image
                child: Image.network(
                  'https://scontent.frak3-1.fna.fbcdn.net/v/t39.30808-6/440096513_944643844024317_8795484264640663375_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHhe-HYv48X9qkonpuoJZUtvvqWwBr1bsa--pbAGvVuxrAhf7ltwBfzWMEa14OAkf8j1dcHfmDlZp8syZaGopHp&_nc_ohc=5B1qtFawGPkQ7kNvgHAKZw4&_nc_zt=23&_nc_ht=scontent.frak3-1.fna&oh=00_AfB03tjNuHqZmC4pu8OhQ7gbPoZjsvF2wZwZEukyMwik1g&oe=663B2A6F', // Replace with the actual URL of your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: Colors.black), // Change text color to black
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              style:
                  TextStyle(color: Colors.black), // Change text color to black
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: Colors.black), // Change text color to black
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              obscureText: true,
              style:
                  TextStyle(color: Colors.black), // Change text color to black
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.blue,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16), // Adjust text size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}
