// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/isar_service.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shop/src/model/product_model.dart';
import 'package:shop/src/model/services/order_service.dart';
import 'package:shop/src/view/widgets/alert.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/cart_item_model.dart';
import '../model/order_model.dart';
import '../model/enums/alert_type.dart';

class CartController extends StateNotifier<AsyncValue<void>> {
  CartController() : super(const AsyncValue.data(null));

  final Alert alert = Alert();
  final IsarService isarService = IsarService();

  void createCart(WidgetRef ref) {
    ref.read(orderProvider.notifier).createCart();
  }

  Future<void> addProductCart(BuildContext context, WidgetRef ref, Product product) async {
    try {
      final order = ref.read(orderProvider.notifier);

      order.addProduct(product);

      await isarService.saveOrderDB(order.state);

      alert.snack(context, AppLocalizations.of(context)!.itemAddedToCart(product.title));
    } catch (e) {
      alert.snack(context, e.toString());
    }
  }

  List<CartItem> listCartItems(WidgetRef ref) {
    return ref.watch(orderProvider.notifier).cartItems();
  }

  Future<void> placeOrder(BuildContext context, WidgetRef ref) async {
    try {
      state = const AsyncValue.loading();

      final orderService = OrderService();
      final order = ref.read(orderProvider.notifier).orderToMap();

      await orderService.addOrder(order);

      alert.dialog(
        context,
        AlertType.warning,
        AppLocalizations.of(context)!.orderPlaced,
      );
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }

    //Todo: Bloco do PDF a ser corrigido.
    /*
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello, PDF!',
              style: const pw.TextStyle(fontSize: 40),
            ),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final output = File('$path/example.pdf');
    await output.writeAsBytes(await pdf.save());
    Navigator.of(context).pop();
    */
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, AsyncValue<void>>((ref) => CartController());
