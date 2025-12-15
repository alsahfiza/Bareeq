import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

class CustomerOrdersService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<OrderModel>> getMyOrders() {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((d) => OrderModel.fromMap(d.id, d.data()))
            .toList());
  }
}
