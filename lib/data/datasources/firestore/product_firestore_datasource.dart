import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';

class ProductFirestoreDatasource {
  final FirebaseFirestore firestore;

  ProductFirestoreDatasource(this.firestore);

  Future<List<ProductModel>> getAll() async {
    final snap = await firestore.collection('products').orderBy('name').get();
    return snap.docs.map(ProductModel.fromFirestore).toList();
  }

  Future<void> save(ProductModel model) async {
    await firestore.collection('products').doc(model.id).set(
          model.data,
          SetOptions(merge: true),
        );
  }
}
