import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  void _signup() async {
    if (_usernameController.text.trim().isEmpty) {
      showToast("Username is required!");
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      showToast("Email is required!");
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      showToast("Address is required!");
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      showToast("Password is required!");
      return;
    }
    if (_passwordController.text.trim().length < 6) {
      showToast("Password must be at least 6 characters!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _addressController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (user != null) {
        showToast("Signup successful! Redirecting...");
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = "Signup failed! Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already registered.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Weak password! Use at least 6 characters.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Network error! Check your internet.";
      }

      showToast(errorMessage);
    } catch (e) {
      setState(() => _isLoading = false);
      showToast("Unexpected Error: ${e.toString()}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _addressController, decoration: InputDecoration(labelText: "Address")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _signup, child: Text("Signup")),
            TextButton(
                onPressed: () => Get.toNamed('/login'),
                child: Text("Already have an account? Login")),
          ],
        ),
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}
