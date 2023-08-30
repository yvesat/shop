import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/product_model.dart';

class ProductsController extends StateNotifier<AsyncValue<void>> {
  ProductsController() : super(const AsyncValue.data(null));

  Product? getProduct(WidgetRef ref, String id) {
    return ref.read(productProvider.notifier).getProductById(id);
  }

  List<Product>? getProductList(WidgetRef ref) {
    return ref.read(productProvider.notifier).getProductList();
  }
}

final productsController = StateNotifierProvider<ProductsController, AsyncValue<void>>((ref) => ProductsController());
