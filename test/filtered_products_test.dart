import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/filtered_products_model.dart';
import 'package:shop/src/model/product_model.dart';

void main() {
  test('ProductNotifier: loadProducts sets initial state', () {
    final container = ProviderContainer();
    final notifier = container.read(filteredProductsProvider.notifier);

    final productsList = [
      Product(id: '1', title: 'Product 1', price: 19.99, imageUrl: 'product-1-image-url'),
      Product(id: '2', title: 'Product 2', price: 29.99, imageUrl: 'product-2-image-url'),
    ];

    notifier.loadProducts(productsList);

    final state = container.read(filteredProductsProvider);

    expect(state.length, 2);
    expect(state[0].title, 'Product 1');
    expect(state[1].title, 'Product 2');
  });

  test('ProductNotifier: filterProductsList filters products', () {
    final container = ProviderContainer();
    final notifier = container.read(filteredProductsProvider.notifier);

    final productsList = [
      Product(id: '1', title: 'Apple', price: 1.99, imageUrl: 'apple-image-url'),
      Product(id: '2', title: 'Banana', price: 0.99, imageUrl: 'banana-image-url'),
      Product(id: '3', title: 'Mango', price: 2.49, imageUrl: 'mango-image-url'),
    ];

    notifier.loadProducts(productsList);
    notifier.filterProductsList(productsList, 'apple');

    final filteredList = notifier.filterdProductsList();

    expect(filteredList.length, 1);
    expect(filteredList[0].title, 'Apple');
  });

  test('ProductNotifier: filterProductsList returns all products for empty query', () {
    final container = ProviderContainer();
    final notifier = container.read(filteredProductsProvider.notifier);

    final productsList = [
      Product(id: '1', title: 'Apple', price: 1.99, imageUrl: 'apple-image-url'),
      Product(id: '2', title: 'Banana', price: 0.99, imageUrl: 'banana-image-url'),
      Product(id: '3', title: 'Mango', price: 2.49, imageUrl: 'mango-image-url'),
    ];

    notifier.loadProducts(productsList);
    notifier.filterProductsList(productsList, '');

    final filteredList = notifier.filterdProductsList();

    expect(filteredList.length, 3);
  });
}
