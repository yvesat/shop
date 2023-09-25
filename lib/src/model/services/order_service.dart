import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  Future<String?> addOrder(Map<String, dynamic> order) async {
    try {
      final db = FirebaseFirestore.instance;

      final documentSnapshot = await db.collection("orders").add(order);

      return documentSnapshot.id;
    } catch (e) {
      rethrow;
    }
  }
}
