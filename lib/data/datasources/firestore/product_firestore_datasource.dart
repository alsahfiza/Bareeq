import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';

class ProductFirestoreDatasource {
  final FirebaseFirestore _firestore;

  ProductFirestoreDatasource(this._firestore);

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  Future<void> createProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }

  Future<void> updateProduct(String productId, ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(productId)
        .update(product.toFirestore());
  }
}
