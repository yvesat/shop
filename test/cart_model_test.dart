import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/order_model.dart';
import 'package:shop/src/model/product_model.dart';

void main() {
  test('CartNotifier: addProduct increments cart and item quantities', () async {
    final container = ProviderContainer();
    final notifier = container.read(orderProvider.notifier);

    // Create a sample product
    Product product = Product(id: '1', title: 'Sample Product', price: 10.0, imageUrl: '');

    notifier.addProduct(product);

    final cart = container.read(orderProvider);

    expect(cart.amount, product.price);
    expect(cart.cartItemList.length, 1);
    expect(cart.cartItemList.first.quantity, 1);

    notifier.addProduct(product);

    final updatedCart = container.read(orderProvider);

    expect(updatedCart.amount, product.price * 2);
    expect(updatedCart.cartItemList.length, 1);
    expect(updatedCart.cartItemList.first.quantity, 2);
  });

  test('CartNotifier: removeProduct removes item from cart', () async {
    final container = ProviderContainer();
    final notifier = container.read(orderProvider.notifier);

    // Create a sample product
    Product product = Product(id: '1', title: 'Sample Product', price: 10.0, imageUrl: '');

    notifier.addProduct(product);

    final cart = container.read(orderProvider);

    expect(cart.amount, product.price);
    expect(cart.cartItemList.length, 1);

    notifier.removeProduct(product);

    final updatedCart = container.read(orderProvider);

    expect(updatedCart.amount, 0);
    expect(updatedCart.cartItemList.length, 0);
  });
}
