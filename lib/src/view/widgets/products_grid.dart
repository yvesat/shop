import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/product_model.dart';

import '../../controller/products_controller.dart';
import 'product_item.dart';

class ProductsGrid extends HookConsumerWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productsControllerProvider);
    final productList = ref.watch(productsControllerProvider.notifier).getProductList(ref);

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

//TODO: CORRIGIR ERRO DE PARENT WIDGET