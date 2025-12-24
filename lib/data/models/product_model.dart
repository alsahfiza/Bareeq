import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final double price;
  final double cost;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.price,
    required this.cost,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'],
      sku: data['sku'],
      barcode: data['barcode'],
      category: data['category'],
      price: (data['price'] as num).toDouble(),
      cost: (data['cost'] as num).toDouble(),
      isActive: data['isActive'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'category': category,
      'price': price,
      'cost': cost,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        sku: sku,
        barcode: barcode,
        category: category,
        price: price,
        cost: cost,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
