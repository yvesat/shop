import 'product_model.dart';

class CartItem {
  String id;
  Product product;
  double totalPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.totalPrice,
    required this.quantity,
  });
}
