import 'package:hooks_riverpod/hooks_riverpod.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void loadProduct(String id, Map<String, dynamic> productData) {
    final newProduct = Product(
      id: id,
      title: productData["title"],
      price: productData["price"].toDouble(),
      imageUrl: productData["imageUrl"],
    );

    state = [...state, newProduct];
  }

  Product? getProductById(String id) {
    return state.firstWhere((e) => e.id == id);
  }

  List<Product> productsList() {
    return state;
  }

  void clearProductState() {
    state = [];
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) => ProductNotifier());
