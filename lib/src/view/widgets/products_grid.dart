import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controller/products_controller.dart';
import 'product_item.dart';

class ProductsGrid extends HookConsumerWidget {
  final bool showOnlyFavorites;

  const ProductsGrid(this.showOnlyFavorites, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsController.notifier);
    final productList = productController.getProductList(ref);
    //final products = showOnlyFavorites ? productsController.favoriteItems : productsController.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productList!.length,
      itemBuilder: (ctx, i) => ProductItem(id: productList[i].id!),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
