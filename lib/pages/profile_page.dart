import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logout() async {
    // Clear the token from secure storage
    await storage.delete(key: 'jwt_token');

    // Navigate to the login page
    Navigator.pushReplacementNamed(context, '/login_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("PROFILE"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'User Profile', // You can add more user details here
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                logout(); // Call the logout function
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
