import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/view/widgets/search_bar.dart';

import '../../controller/login_controller.dart';
import '../../controller/products_controller.dart';
import '../widgets/products_grid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeController = ref.read(loginControllerProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => homeController.logOff(context, ref),
          icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
        ),
        centerTitle: true,
        title: const Text("Shop"),
        actions: [
          IconButton(
            onPressed: () => context.go('/home/cart'),
            icon: const FaIcon(FontAwesomeIcons.cartShopping),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomSearchBar(
              controller: controller,
              onChanged: (value) => ref.read(productsControllerProvider.notifier).filterProducts(ref, value),
            ),
            const Expanded(child: ProductsGrid()),
          ],
        ),
      ),
    );
  }
}
