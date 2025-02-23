import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> womensClothCollection = [
    {"name": "Crimson Bloom Crop Top", "price": "\$590", "oldPrice": "\$690", "image": "assets/images/women1.webp"},
    {"name": "Classic Chic Cardigan", "price": "\$590", "oldPrice": "", "image": "assets/images/women2.webp"},
    {"name": "Red Radiance Blazer", "price": "\$590", "oldPrice": "\$690", "image": "assets/images/women3.jpg"},
  ];

  final List<Map<String, dynamic>> mensClothCollection = [
    {"name": "Crimson Crest Shirt", "price": "\$590", "oldPrice": "\$690", "image": "assets/images/men1.webp"},
    {"name": "Indigo Edge Denim Jacket", "price": "\$590", "oldPrice": "\$690", "image": "assets/images/men2.webp"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce App"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () => Get.toNamed('/cart'), icon: Icon(Icons.shopping_cart)),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryTabs(),
            _buildSectionTitle("Shop By Brands"),
            _buildBrandCategories(),
            _buildSectionTitle("Women’s Cloth Collection"),
            _buildProductList(womensClothCollection),
            _buildSectionTitle("Men’s Cloth Collection"),
            _buildProductList(mensClothCollection),
            _buildSectionTitle("Flash Sale"),
            _buildFlashSale(),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/icon/avatar.png")),
                SizedBox(height: 10),
                Text("Welcome, User!", style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          _buildDrawerItem("Home", Icons.home, () => Get.toNamed('/home')),
          _buildDrawerItem("Product List", Icons.list, () => Get.toNamed('/products')),
          _buildDrawerItem("Cart", Icons.shopping_cart, () => Get.toNamed('/cart')),
          _buildDrawerItem("Profile", Icons.person, () => Get.toNamed('/profile')),
          _buildDrawerItem("Logout", Icons.logout, () async {
            await FirebaseAuth.instance.signOut();
            Get.offAllNamed('/login');
          }),
        ],
      ),
    );
  }
  // Function to create drawer menu items
  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryTab("Mens"),
          _buildCategoryTab("Women"),
          _buildCategoryTab("Kids"),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return GestureDetector(
      onTap: () {},
      child: Chip(
        label: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBrandCategories() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildCategoryIcon("Shoes"),
          _buildCategoryIcon("Watches"),
          _buildCategoryIcon("Heels"),
          _buildCategoryIcon("Bags & Bag Packs"),
          _buildCategoryIcon("Sunglasses"),
          _buildCategoryIcon("Jewellery"),
          _buildCategoryIcon("Beauty & Make Up"),
          _buildCategoryIcon("Perfume"),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String title) {
    return Chip(
      label: Text(title),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 160,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(product["image"], fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(product["price"], style: TextStyle(color: Colors.green)),
                  if (product["oldPrice"].isNotEmpty)
                    Text(product["oldPrice"], style: TextStyle(decoration: TextDecoration.lineThrough)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashSale() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text("Limited Time Offer! 50% Off!", style: TextStyle(color: Colors.white, fontSize: 18))),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Frequently Asked Questions"),
          _buildFAQItem("How can I place an order?"),
          _buildFAQItem("Is COD (Cash on Delivery) available?"),
          _buildFAQItem("What is your cancellation policy?"),
          _buildFAQItem("What is your return policy?"),
          _buildFAQItem("Do you offer international shipping?"),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text("• $question", style: TextStyle(fontSize: 16)),
    );
  }
}
