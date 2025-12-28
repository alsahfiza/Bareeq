import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sale_model.dart';

class SaleFirestoreDatasource {
  final FirebaseFirestore firestore;

  SaleFirestoreDatasource(this.firestore);

  Future<List<SaleModel>> getAll({
    DateTime? from,
    DateTime? to,
  }) async {
    Query query = firestore.collection('sales');

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

    final snap = await query.orderBy('createdAt', descending: true).get();
    return snap.docs.map(SaleModel.fromFirestore).toList();
  }
}
