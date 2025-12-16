import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getAllProducts() {
    return _ref.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (d) => ProductModel.fromMap(
                  d.id,
                  d.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<ProductModel>> getProductsByCategory(
      String categoryId) {
    return _ref
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (d) => ProductModel.fromMap(
                  d.id,
                  d.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<ProductModel>> getLowStockProducts(
      int threshold) {
    return _ref
        .where('stock', isLessThanOrEqualTo: threshold)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (d) => ProductModel.fromMap(
                  d.id,
                  d.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> addProduct(ProductModel product) async {
    await _ref.add(product.toMap());
  }

  Future<void> updateProduct(
      String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  Future<void> deleteProduct(String id) async {
    await _ref.doc(id).delete();
  }
}
