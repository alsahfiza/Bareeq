import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    var ref = await _db.collection('categories').get();
    return ref.docs.map((d) => CategoryModel.fromMap(d.id, d.data())).toList();
  }

  Future<List<ProductModel>> getProducts(String categoryId) async {
    var ref = await _db.collection('products')
      .where('category_id', isEqualTo: categoryId)
      .get();
    return ref.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList();
  }

  Future<ProductModel> getProduct(String id) async {
    var ref = await _db.collection('products').doc(id).get();
    return ProductModel.fromMap(ref.id, ref.data()!);
  }

  Future<List<ProductModel>> searchProducts(String text) async {
    var ref = await _db.collection('products')
      .where('keywords', arrayContains: text.toLowerCase())
      .get();
    return ref.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList();
  }

}
