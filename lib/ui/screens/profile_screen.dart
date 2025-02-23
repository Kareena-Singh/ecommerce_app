import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: user == null
          ? Center(child: Text("No user logged in"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/icon/avatar.png'), // Use an image asset
                  ),
                  SizedBox(height: 20),
                  Text(user.email ?? "No Email",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Address: 123, Sample Street, City",
                      style: TextStyle(fontSize: 16)), // Static for now
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _authService.logout();
                      Get.offAllNamed('/'); // Navigate to login screen
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
    );
  }
}
