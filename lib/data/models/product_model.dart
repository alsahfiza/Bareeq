import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final Map<String, dynamic> data;

  ProductModel(this.id, this.data);

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    return ProductModel(doc.id, doc.data() as Map<String, dynamic>);
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      barcode: data['barcode'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      cost: (data['cost'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> fromEntity(ProductEntity e) {
    return {
      'name': e.name,
      'sku': e.sku,
      'barcode': e.barcode,
      'category': e.category,
      'price': e.price,
      'cost': e.cost,
      'isActive': e.isActive,
      'createdAt': Timestamp.fromDate(e.createdAt),
      'updatedAt': Timestamp.fromDate(e.updatedAt),
    };
  }
}
