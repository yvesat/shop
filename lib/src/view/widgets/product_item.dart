import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controller/cart_controller.dart';
import '../../controller/products_controller.dart';
import 'custom_grid_tile_bar.dart';

class ProductItem extends HookConsumerWidget {
  final String id;
  const ProductItem({required this.id, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider.notifier);
    final product = productController.getProduct(ref, id);
    final cartController = ref.read(cartControllerProvider.notifier);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          GridTile(
            footer: CustomGridTileBar(
              title: Text(
                product!.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
              trailing: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await cartController.addProductCart(context, ref, product);
                  },
                  icon: FaIcon(FontAwesomeIcons.cartShopping, size: 16, color: Theme.of(context).colorScheme.secondary)),
            ),
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
