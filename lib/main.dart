import 'package:ecommerce_app/ui/screens/CartScreen.dart';
import 'package:ecommerce_app/ui/screens/ProductDetailScreen.dart';
import 'package:ecommerce_app/ui/screens/SplashScreen.dart';
import 'package:ecommerce_app/ui/screens/home_screen.dart';
import 'package:ecommerce_app/ui/screens/login_screen.dart';
import 'package:ecommerce_app/ui/screens/product_list_screen.dart';
import 'package:ecommerce_app/ui/screens/profile_screen.dart';
import 'package:ecommerce_app/ui/screens/signup_screen.dart';
import 'package:ecommerce_app/ui/widgets/CartController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CartController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/products': (context) => ProductListScreen(),
        '/product_detail': (context) => ProductDetailScreen(),
        '/cart': (context) => CartScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
