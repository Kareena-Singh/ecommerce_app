import 'package:get/get.dart';
import '../../data/models/Product.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
}
