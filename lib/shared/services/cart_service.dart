import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';

class CartService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<CartItem>> getCart() {
    return _db.collection('carts').doc(_uid).snapshots().map((doc) {
      if (!doc.exists) return [];
      final items = List<Map<String, dynamic>>.from(doc['items']);
      return items.map((e) => CartItem.fromMap(e)).toList();
    });
  }

  Future<void> addToCart(CartItem item, int maxStock) async {
    final ref = _db.collection('carts').doc(_uid);
    final snap = await ref.get();

    List<CartItem> items = [];

    if (snap.exists) {
      items = List<Map<String, dynamic>>.from(snap['items'])
          .map((e) => CartItem.fromMap(e))
          .toList();
    }

    final index = items.indexWhere((i) => i.productId == item.productId);

    if (index >= 0) {
      final newQty = items[index].qty + 1;
      if (newQty > maxStock) return;

      items[index] = CartItem(
        productId: item.productId,
        name: item.name,
        price: item.price,
        qty: newQty,
      );
    } else {
      items.add(item);
    }

    await ref.set({'items': items.map((e) => e.toMap()).toList()});
  }

  Future<void> updateQty(String productId, int qty) async {
    final ref = _db.collection('carts').doc(_uid);
    final snap = await ref.get();

    if (!snap.exists) return;

    final items = List<Map<String, dynamic>>.from(snap['items'])
        .map((e) => CartItem.fromMap(e))
        .toList();

    final index = items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      items[index] = CartItem(
        productId: items[index].productId,
        name: items[index].name,
        price: items[index].price,
        qty: qty,
      );
    }

    await ref.update({'items': items.map((e) => e.toMap()).toList()});
  }

  Future<void> removeFromCart(String productId) async {
    final ref = _db.collection('carts').doc(_uid);
    final snap = await ref.get();
    if (!snap.exists) return;

    final items = List<Map<String, dynamic>>.from(snap['items'])
        .map((e) => CartItem.fromMap(e))
        .where((i) => i.productId != productId)
        .toList();

    await ref.update({'items': items.map((e) => e.toMap()).toList()});
  }
}
