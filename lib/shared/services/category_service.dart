import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final _ref = FirebaseFirestore.instance.collection('categories');

  Stream<List<CategoryModel>> getCategories({bool activeOnly = false}) {
    Query query = _ref.orderBy('order');

    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }

    return query.snapshots().map((s) =>
        s.docs.map((d) => CategoryModel.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addCategory(CategoryModel category) async {
    await _ref.add(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _ref.doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _ref.doc(id).delete();
  }
}
