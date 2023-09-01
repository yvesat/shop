import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/filtered_products_model.dart';
import 'product_item.dart';

class ProductsGrid extends HookConsumerWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(filteredProductsProvider);
    final productList = ref.watch(filteredProductsProvider.notifier).filterdProductsList();

    return GridView.builder(
      shrinkWrap: true,
      itemCount: productList.length,
      itemBuilder: (ctx, i) => ProductItem(id: productList[i].id),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
    );
  }
}
