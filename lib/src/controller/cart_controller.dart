import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/product_model.dart';
import 'package:shop/src/view/widgets/alert.dart';

import '../model/cart_model.dart';

class CartController extends StateNotifier<AsyncValue<void>> {
  CartController() : super(const AsyncValue.data(null));

  final Alert alert = Alert();

  void createCart(WidgetRef ref) {
    ref.read(cartProvider.notifier).createCart();
  }

  void addProductCart(BuildContext context, WidgetRef ref, Product product) {
    try {
      ref.read(cartProvider.notifier).addProduct(product);
      alert.snack(context, "Item ${product.title} added to cart!");
    } catch (e) {
      alert.snack(context, e.toString());
    }
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, AsyncValue<void>>((ref) => CartController());

//TODO: LANGUAGE