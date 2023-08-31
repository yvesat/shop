import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/view/widgets/search_bar.dart';

import '../controller/home_controller.dart';
import '../controller/products_controller.dart';
import 'widgets/products_grid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeController = ref.read(homeControllerProvider.notifier);
    final productsController = ref.read(productsControllerProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => homeController.logOff(context),
          icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
        ),
        centerTitle: true,
        title: const Text("Shop"),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => context.go('/cart'),
            icon: const FaIcon(FontAwesomeIcons.cartShopping),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: ProductsGrid(),
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 16),
      //         child: CustomSearchBar(
      //           controller: controller,
      //           onChanged: (value) {
      //             // productsController.filterProducts(ref, value);
      //           },
      //         ),
      //       ),
      //       const ProductsGrid(),
      //     ],
      //   ),
      // ),
    );
  }
}


//TODO: LANGUAGE
//TODO: CORRIGIR ERRO DE PARENT WIDGET