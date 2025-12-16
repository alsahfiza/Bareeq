import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersService {
  final _ref = FirebaseFirestore.instance.collection('orders');
  static const int pageSize = 10;

  Query<Map<String, dynamic>> baseQuery({
    required String status,
  }) {
    Query<Map<String, dynamic>> q =
        _ref.orderBy('createdAt', descending: true);

    if (status != 'all') {
      q = q.where('status', isEqualTo: status);
    }

    return q.limit(pageSize);
  }

  Query<Map<String, dynamic>> nextPage({
    required String status,
    required DocumentSnapshot lastDoc,
  }) {
    Query<Map<String, dynamic>> q =
        _ref.orderBy('createdAt', descending: true);

    if (status != 'all') {
      q = q.where('status', isEqualTo: status);
    }

    return q.startAfterDocument(lastDoc).limit(pageSize);
  }
}
