import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';

class CartSyncService {
  static Future<void> syncCartToFirestore(List<CartItem> items) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .doc("data")
        .set({
      "items": items.map((e) {
        return {
          "id": e.id,
          "nameAr": e.nameAr,
          "imageUrl": e.imageUrl,
          "price": e.price,
          "quantity": e.quantity,
        };
      }).toList(),
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  static Future<List<CartItem>> loadCartFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .doc("data")
        .get();

    if (!doc.exists) return [];

    List items = doc["items"];

    return items.map((e) {
      return CartItem(
        id: e["id"],
        nameAr: e["nameAr"],
        imageUrl: e["imageUrl"],
        price: e["price"],
        quantity: e["quantity"],
      );
    }).toList();
  }
}
