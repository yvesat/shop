import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/enums/alert_type.dart';
import 'package:shop/src/view/widgets/alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/cart_controller.dart';
import '../widgets/button.dart';
import '../widgets/progress.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);
    final cartController = ref.read(cartControllerProvider.notifier);
    final cartItems = cartController.listCartItems(ref);
    final Alert alert = Alert();
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
        ),
        centerTitle: true,
        title: const Text("Shop"),
        // actions: [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ListTile(
                        tileColor: Theme.of(context).colorScheme.secondaryContainer,
                        title: Text(
                          cartItems[index].title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.cartItemQuantity(cartItems[index].quantity.toString())),
                            const Spacer(),
                            Text(AppLocalizations.of(context)!.cartItemTotalPrice(cartItems[index].totalPrice!.toStringAsFixed(2))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Button(
                    label: AppLocalizations.of(context)!.placeOrder,
                    onTap: cartItems.isNotEmpty
                        ? () {
                            alert.dialog(
                              context,
                              AlertType.warning,
                              AppLocalizations.of(context)!.confirmPlaceOrder,
                              onPress: () async {
                                Navigator.of(context).pop();
                                await cartController.placeOrder(context, ref);
                              },
                            );
                          }
                        : null),
              ],
            ),
          ),
          if (cartState.isLoading) Progress(size),
        ],
      ),
    );
  }
}
