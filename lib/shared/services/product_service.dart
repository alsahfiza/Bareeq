import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../../core/constants.dart';

class ProductService {
  final _ref = FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getProducts() {
    return _ref.snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<ProductModel>> getLowStockProducts() {
    return _ref
        .where('stock', isLessThanOrEqualTo: LOW_STOCK_THRESHOLD)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs
                .map((doc) =>
                    ProductModel.fromMap(doc.id, doc.data()))
                .toList());
  }

  Future<void> addProduct(ProductModel product) async {
    await _ref.add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _ref.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _ref.doc(id).delete();
  }
}
