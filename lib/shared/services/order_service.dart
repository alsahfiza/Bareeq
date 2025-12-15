import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((d) => OrderModel.fromMap(d.id, d.data()))
            .toList());
  }

  /// ACCEPT ORDER → deduct stock (transaction)
  Future<void> acceptOrder(OrderModel order) async {
    await _db.runTransaction((tx) async {
      for (final item in order.items) {
        final productRef = _db.collection('products').doc(item.productId);
        final snap = await tx.get(productRef);

        final currentStock = snap['stock'];
        if (currentStock < item.qty) {
          throw Exception('Insufficient stock');
        }

        tx.update(productRef, {
          'stock': currentStock - item.qty,
        });

        // log movement
        tx.set(_db.collection('inventory').doc(), {
          'productId': item.productId,
          'qty': item.qty,
          'type': 'OUT',
          'reason': 'Order ${order.id}',
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      tx.update(_db.collection('orders').doc(order.id), {
        'status': 'accepted',
      });
    });
  }

  /// DECLINE ORDER → no stock change
  Future<void> declineOrder(String orderId, String reason) async {
    await _db.collection('orders').doc(orderId).update({
      'status': 'declined',
      'declineReason': reason,
    });
  }
}
