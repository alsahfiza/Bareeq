import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api.dart';
import 'picture_provider.dart';

class ProductsProvider extends ChangeNotifier {
  final Api _api = Api(path: 'products');
  final pictureProvider = PicturesProvider();
  Stream<List<ProductModel>> get fetchProductsStream {
    return FirebaseFirestore.instance.collection('products').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return ProductModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Stream<ProductModel?> fetchProductById(String productId) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: productId) // Filter by product ID
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return ProductModel.fromFirestore(snapshot.docs.first);
      }
      return null; // Return null if no product is found
    });
  }

  Future deleteProduct(
      {required String id,
      required List<String> imageUrlsOnFirebaseStorage}) async {
    await _api.removeDocument(id);
    pictureProvider.deletePictures(picturePaths: imageUrlsOnFirebaseStorage);

    notifyListeners();
    return;
  }

  Future updateProduct(ProductModel data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    notifyListeners();
    return;
  }

  Future addProduct(ProductModel data) async {
    await _api.addDocument(productModel: data).whenComplete(() {
      notifyListeners();
    });
    return;
  }
}
