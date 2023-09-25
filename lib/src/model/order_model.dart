import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import 'cart_item_model.dart';
import 'product_model.dart';

part 'order_model.g.dart';

@collection
class Order {
  Id id = Isar.autoIncrement;
  String firebaseId = "";
  double amount;
  List<CartItem> cartItemList = [];

  Order({required this.amount, required this.cartItemList});
}

class OrderNotifier extends StateNotifier<Order> {
  OrderNotifier() : super(Order(amount: 0.0, cartItemList: []));

  void createCart() {
    final newCart = Order(
      amount: 0.0,
      cartItemList: [],
    );

    state = newCart;
  }

  void loadCart(Order order) {
    state = order;
  }

  List<CartItem> cartItems() {
    return state.cartItemList;
  }

  void addProduct(Product product) {
    final bool productIsInCart = state.cartItemList.any((cartItem) => cartItem.id == product.id);

    if (productIsInCart) {
      final itemInCart = state.cartItemList.firstWhere((cartItem) => cartItem.id == product.id);
      itemInCart.quantity! + 1;
      itemInCart.totalPrice = itemInCart.totalPrice! + product.price;
      state.amount += product.price;
    } else {
      final newCartItem = CartItem(
        id: product.id,
        title: product.title,
        totalPrice: product.price,
        price: product.price,
        quantity: 1,
      );
      state.cartItemList.add(newCartItem);
      state.amount += newCartItem.totalPrice!;
    }
  }

  Map<String, dynamic> orderToMap() {
    List<Map<String, dynamic>> productsList = [];

    for (CartItem cartItem in state.cartItemList) {
      final Map<String, dynamic> product = {
        "id": cartItem.id,
        "totalPrice": cartItem.totalPrice,
        "quantity": cartItem.quantity,
      };

      productsList.add(product);
    }
    return {
      "amount": state.amount,
      "products": productsList,
    };
  }

  void removeProduct(Product product) {}
}

final orderProvider = StateNotifierProvider<OrderNotifier, Order>((ref) => OrderNotifier());
