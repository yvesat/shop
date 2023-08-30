import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controller/products_controller.dart';
import 'custom_grid_tile_bar.dart';

class ProductItem extends HookConsumerWidget {
  final String id;
  const ProductItem({required this.id, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsController.notifier);
    final product = productController.getProduct(ref, id);
    //final cart = Provider.of<Cart>(context, listen: false);
    //final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          GridTile(
            child: GestureDetector(
              onTap: () {
                //TODO: IMPLEMENTAR
              },
              child: Image.network(product!.imageUrl, fit: BoxFit.cover),
            ),
            footer: CustomGridTileBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
              // trailing: IconButton(
              //     padding: EdgeInsets.zero,
              //     onPressed: () {
              //       cart.addItem(product.id!, product.imageUrl, product.price, product.title);
              //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: const Text('Added item do cart!'),
              //           duration: const Duration(seconds: 2),
              //           action: SnackBarAction(
              //             label: 'UNDO',
              //             onPressed: () {
              //               cart.subtractQuantity(product.id!);
              //             },
              //           ),
              //         ),
              //       );
              //     },
              //     icon: FaIcon(FontAwesomeIcons.cartShopping, size: 16, color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: FaIcon(product.isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16, color: Theme.of(context).colorScheme.onErrorContainer),
                ),
              ),
              onTap: () async {
                // bool toggledFavorite = await product.toggleFavorite(authData.token!, authData.userId!);
                // if (!toggledFavorite) {
                //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Failed updating favorite status!', textAlign: TextAlign.center),
                //       duration: Duration(seconds: 4),
                //     ),
                //   );
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
