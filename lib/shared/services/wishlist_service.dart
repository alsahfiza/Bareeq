import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<String>> getWishlistIds() {
    return _db.collection('wishlists').doc(_uid).snapshots().map((doc) {
      if (!doc.exists) return [];
      return List<String>.from(doc['items']);
    });
  }

  Future<void> toggleWishlist(String productId) async {
    final ref = _db.collection('wishlists').doc(_uid);
    final snap = await ref.get();

    List<String> items = [];
    if (snap.exists) {
      items = List<String>.from(snap['items']);
    }

    items.contains(productId)
        ? items.remove(productId)
        : items.add(productId);

    await ref.set({'items': items});
  }
}
