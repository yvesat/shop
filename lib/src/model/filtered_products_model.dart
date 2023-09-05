import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/product_model.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void loadProducts(List<Product> productsList) {
    state = productsList;
  }

  void filterProductsList(List<Product> productsList, String query) {
    List<Product> listaFiltrada = [];

    if (query.isEmpty) {
      state = productsList;
    } else {
      listaFiltrada = productsList.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
      state = listaFiltrada;
    }
  }

  List<Product> filterdProductsList() {
    return state;
  }
}

final filteredProductsProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) => ProductNotifier());
