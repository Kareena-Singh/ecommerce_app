import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/Product.dart';
import '../../data/services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  late Future<List<Product>> _productsFuture;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedSort = "Price: Low to High";
  String _selectedCategory = "All";
  int _itemsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    _productsFuture = ProductService.fetchProducts();
    _productsFuture.then((products) {
      setState(() {
        _products = products;

        //  Debug: Print all unique categories from API
        print("Fetched Categories: ${_products.map((p) => p.category).toSet()}");

        _filteredProducts = _applyFilters();
      });
    });
  }

  List<Product> _applyFilters() {
    List<Product> filtered = _products;

    //  Apply Category Filter (Case-Insensitive)
    if (_selectedCategory != "All") {
      filtered = filtered.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    //  Apply Sorting
    switch (_selectedSort) {
      case "Price: Low to High":
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Price: High to Low":
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "Name A-Z":
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Name Z-A":
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return filtered;
  }


  void _onSortChanged(String? newValue) {
    setState(() {
      _selectedSort = newValue!;
      _filteredProducts = _applyFilters();
    });
  }

  void _onCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategory = newValue!;
      _filteredProducts = _applyFilters();
    });
  }

  void _loadMore() {
    setState(() {
      _itemsPerPage += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: Column(
        children: [
          _buildFilterAndSortOptions(),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (_filteredProducts.isEmpty) {
                  return Center(child: Text("No products found"));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _filteredProducts.length.clamp(0, _itemsPerPage),
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
          if (_itemsPerPage < _filteredProducts.length)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: _loadMore,
                child: Text("Load More"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedCategory,
            items: ["All", "men's clothing", "jewelery", "electronics", "women's clothing"]
                .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                .toList(),
            onChanged: _onCategoryChanged,
          ),
          DropdownButton<String>(
            value: _selectedSort,
            items: ["Price: Low to High", "Price: High to Low", "Name A-Z", "Name Z-A"]
                .map((sortOption) => DropdownMenuItem(value: sortOption, child: Text(sortOption)))
                .toList(),
            onChanged: _onSortChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed('/product_detail', arguments: product),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(product.image, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text("\$${product.price}", style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
