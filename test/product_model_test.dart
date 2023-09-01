import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/product_model.dart';

void main() {
  test('ProductNotifier: loadProduct adds product to state', () {
    final container = ProviderContainer();
    final notifier = container.read(productProvider.notifier);

    const productId = '1';
    const productData = {
      'title': 'Sample Product',
      'price': 9.99,
      'imageUrl': 'sample-image-url',
    };

    notifier.loadProduct(productId, productData);

    final state = container.read(productProvider);

    expect(state.length, 1);
    expect(state[0].id, productId);
    expect(state[0].title, 'Sample Product');
    expect(state[0].price, 9.99);
    expect(state[0].imageUrl, 'sample-image-url');
  });

  test('ProductNotifier: getProductById returns correct product', () {
    final container = ProviderContainer();
    final notifier = container.read(productProvider.notifier);

    const productId = '1';
    const productData = {
      'title': 'Sample Product',
      'price': 9.99,
      'imageUrl': 'sample-image-url',
    };

    notifier.loadProduct(productId, productData);

    final product = notifier.getProductById(productId);

    expect(product, isNotNull);
    expect(product!.title, 'Sample Product');
  });

  test('ProductNotifier: productsList returns correct list', () {
    final container = ProviderContainer();
    final notifier = container.read(productProvider.notifier);

    const productData1 = {
      'title': 'Product 1',
      'price': 19.99,
      'imageUrl': 'product-1-image-url',
    };

    const productData2 = {
      'title': 'Product 2',
      'price': 29.99,
      'imageUrl': 'product-2-image-url',
    };

    notifier.loadProduct('1', productData1);
    notifier.loadProduct('2', productData2);

    final productList = notifier.productsList();

    expect(productList.length, 2);
    expect(productList[0].title, 'Product 1');
    expect(productList[1].title, 'Product 2');
  });

  test('ProductNotifier: clearProductState clears the state', () {
    final container = ProviderContainer();
    final notifier = container.read(productProvider.notifier);

    const productData = {
      'title': 'Sample Product',
      'price': 9.99,
      'imageUrl': 'sample-image-url',
    };

    notifier.loadProduct('1', productData);
    notifier.clearProductState();

    final state = container.read(productProvider);

    expect(state.isEmpty, true);
  });
}
