import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/product_model.dart';

class Cart {
  String id = "";
  double amount;
  List<Product> productList = [];

  Cart({required this.amount, required this.productList});
}

class CartNotifier extends StateNotifier<Cart?> {
  CartNotifier() : super(Cart(amount: 0.0, productList: []));

  void createCart() {
    // double amount = 0.0;
    // if (productList.isNotEmpty) {
    //   for (Product product in productList) {
    //     amount += product.price;
    //   }
    // }
    final newCart = Cart(
      amount: 0.0,
      productList: [],
    );

    state = newCart;
  }

  List<Product> cartItems() {
    return state!.productList;
  }

  void addProduct(Product product) {
    state!.productList.add(product);
    state!.amount += product.price;
  }

  // void removeProduct(String cartId, String productId) {
  //   final cart = state.firstWhere((cart) => cart.id == cartId);

  //   final product = cart.productList.firstWhere((product) => product.id == productId);
  //   cart.productList.removeWhere((product) => product.id == productId);
  // }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart?>((ref) => CartNotifier());
