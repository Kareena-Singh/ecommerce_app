import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/Product.dart';
import '../widgets/CartController.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.image, height: 250),
            SizedBox(height: 20),
            Text(product.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("\$${product.price}", style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            Text(product.description, textAlign: TextAlign.justify),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cartController.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Added to cart!")),
                );
              },
              child: Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
