import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/cart_model.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartController = ref.watch(cartProvider.notifier);
    final cartItems = cartController.cartItems();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shop"),
        // actions: [],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (ctx, index) => ListTile(
              leading: Text(cartItems[index].title),
            ),
          )),
    );
  }
}

//TODO: LANGUAGE
