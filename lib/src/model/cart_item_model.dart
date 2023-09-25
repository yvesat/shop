import 'package:isar/isar.dart';

part 'cart_item_model.g.dart';

@embedded
class CartItem {
  String? id;
  String? title;
  double? price;
  double? totalPrice;
  int? quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.totalPrice,
    this.quantity,
  });
}
