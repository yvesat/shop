import 'package:hooks_riverpod/hooks_riverpod.dart';

class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  Product? getProductById(String id) {
    return state.firstWhere((e) => e.id == id);
  }

  List<Product>? getProductList() {
    return state;
  }

  void toggleFavorite(String id) {
    state = [
      for (final productState in state)
        if (productState.id == id) productState.copyWith(isFavorite: productState.isFavorite = !productState.isFavorite) else productState,
    ];
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) => ProductNotifier());
