import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sale_model.dart';

class SalesFirestoreDatasource {
  final FirebaseFirestore _firestore;

  SalesFirestoreDatasource(this._firestore);

  Future<List<SaleModel>> getSales({
    DateTime? from,
    DateTime? to,
  }) async {
    Query query = _firestore.collection('sales');

    if (from != null) {
      query = query.where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(from),
      );
    }

    if (to != null) {
      query = query.where(
        'createdAt',
        isLessThanOrEqualTo: Timestamp.fromDate(to),
      );
    }

    final snapshot = await query
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SaleModel.fromFirestore(doc))
        .toList();
  }
}
