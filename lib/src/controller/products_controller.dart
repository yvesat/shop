import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/filtered_products_model.dart';
import '../model/product_model.dart';

class ProductsController extends StateNotifier<AsyncValue<void>> {
  ProductsController() : super(const AsyncValue.data(null));

  final db = FirebaseFirestore.instance;

  Product? getProduct(WidgetRef ref, String id) {
    return ref.read(productProvider.notifier).getProductById(id);
  }

  List<Product> filteredProducts(WidgetRef ref) {
    return ref.watch(filteredProductsProvider.notifier).filterdProductsList();
  }

  void filterProducts(WidgetRef ref, String query) {
    final originalState = ref.watch(productProvider.notifier).productsList();
    ref.read(filteredProductsProvider.notifier).filterProductsList(originalState, query);
  }

  Future<void> loadProducts(WidgetRef ref) async {
    await db.collection("products").get().then((event) {
      for (var product in event.docs) {
        ref.read(productProvider.notifier).loadProduct(product.id, product.data());
      }
    });
  }
}

final productsControllerProvider = StateNotifierProvider<ProductsController, AsyncValue<void>>((ref) => ProductsController());
