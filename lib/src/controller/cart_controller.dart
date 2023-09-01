import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/src/model/product_model.dart';
import 'package:shop/src/view/widgets/alert.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/cart_item_model.dart';
import '../model/cart_model.dart';

class CartController extends StateNotifier<AsyncValue<void>> {
  CartController() : super(const AsyncValue.data(null));

  final Alert alert = Alert();

  void createCart(WidgetRef ref) {
    ref.read(cartProvider.notifier).createCart();
  }

  void addProductCart(BuildContext context, WidgetRef ref, Product product) {
    try {
      ref.read(cartProvider.notifier).addProduct(product);
      alert.snack(context, AppLocalizations.of(context)!.itemAddedToCart(product.title));
    } catch (e) {
      alert.snack(context, e.toString());
    }
  }

  List<CartItem> listCartItems(WidgetRef ref) {
    return ref.watch(cartProvider.notifier).cartItems();
  }

  Future<void> placeOrder(BuildContext context) async {
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
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, AsyncValue<void>>((ref) => CartController());
