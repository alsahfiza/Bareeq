import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sale_entity.dart';

class SaleModel {
  final String id;
  final Map<String, dynamic> data;

  SaleModel(this.id, this.data);

  factory SaleModel.fromFirestore(DocumentSnapshot doc) {
    return SaleModel(doc.id, doc.data() as Map<String, dynamic>);
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      total: (data['total'] ?? 0).toDouble(),
      profit: (data['profit'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
