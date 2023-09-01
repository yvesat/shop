import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/cart_item_model.dart';

import 'product_model.dart';

class Cart {
  String id = "";
  double amount;
  List<CartItem> cartItemList = [];

  Cart({required this.amount, required this.cartItemList});
}

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart(amount: 0.0, cartItemList: []));

  void createCart() {
    final newCart = Cart(
      amount: 0.0,
      cartItemList: [],
    );

    state = newCart;
  }

  List<CartItem> cartItems() {
    return state.cartItemList;
  }

  void addProduct(Product product) {
    final bool productIsInCart = state.cartItemList.any((cartItem) => cartItem.product.id == product.id);

    if (productIsInCart) {
      final itemInCart = state.cartItemList.firstWhere((cartItem) => cartItem.product.id == product.id);
      itemInCart.quantity++;
      itemInCart.totalPrice += product.price;
      state.amount += product.price;
    } else {
      final newCartItem = CartItem(
        id: product.id,
        product: product,
        totalPrice: product.price,
        quantity: 1,
      );
      state.cartItemList.add(newCartItem);
      state.amount += newCartItem.totalPrice;
    }
  }

  void removeProduct(Product product) {}
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) => CartNotifier());
