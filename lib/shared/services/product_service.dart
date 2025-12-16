import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> streamProducts() {
    return _ref.snapshots().map(
          (s) => s.docs
              .map((d) =>
                  ProductModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<ProductModel>> getLowStockProducts(
      int threshold) {
    return _ref
        .where(
          'stock',
          isLessThanOrEqualTo: threshold,
        )
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) =>
                  ProductModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> add(ProductModel product) async {
    try {
      await _ref.add(product.toMap());
      print('✅ Product added');
    } catch (e) {
      print('❌ Add product failed: $e');
      rethrow;
    }
  }

  Future<void> update(
      String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update(data);
      print('✅ Product updated');
    } catch (e) {
      print('❌ Update product failed: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      print('✅ Product deleted');
    } catch (e) {
      print('❌ Delete product failed: $e');
      rethrow;
    }
  }
}
