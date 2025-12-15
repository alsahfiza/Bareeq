import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';

class CheckoutService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> createOrder({
    required List<CartItem> items,
    required double deliveryFee,
  }) async {
    final subtotal = items.fold<double>(
      0,
      (s, i) => s + (i.price * i.qty),
    );

    final total = subtotal + deliveryFee;

    final ref = _db.collection('orders').doc();

    await ref.set({
      'userId': _uid,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': 'pending_payment',
      'createdAt': DateTime.now().toIso8601String(),
    });

    return ref.id;
  }

  Future<void> clearCart() async {
    await _db.collection('carts').doc(_uid).delete();
  }
}
