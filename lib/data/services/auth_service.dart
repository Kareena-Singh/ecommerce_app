import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign Up & Store User Details
  Future<User?> signUp(String email, String password, String username, String address) async {
    try {
      print(" Attempting to sign up user...");

      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: "user-null",
          message: "User creation failed unexpectedly.",
        );
      }

      print("User created successfully: ${user.uid}");

      // Store user data in Firestore
      Map<String, dynamic> userData = {
        "username": username,
        "email": email,
        "address": address,
        "uid": user.uid,
        "createdAt": FieldValue.serverTimestamp(), // Timestamp for user creation
      };

      await _db.collection("users").doc(user.uid).set(userData);
      print(" User data stored in Firestore");

      return user;
    } on FirebaseAuthException catch (e) {
      print(" Firebase Auth Error: ${e.message}");
      throw Exception("FirebaseAuthException: ${e.message}");
    } catch (e) {
      print(" Unexpected Error: $e");
      throw Exception("Unexpected Error: ${e.toString()}");
    }
  }

  // Login Function
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout Function
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check if user is logged in
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
