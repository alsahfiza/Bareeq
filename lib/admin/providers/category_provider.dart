import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../models/product_category_models.dart';


// ==================== CATEGORY PROVIDER ====================
class CategoryProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get activeCategories => 
      _categories.where((c) => c.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('categories')
          .orderBy('sortOrder')
          .orderBy('name')
          .get();

      _categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
      
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Listen to categories in real-time
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firebaseService.getCollectionStream(
      collection: 'categories',
      queryBuilder: (query) => query.orderBy('sortOrder').orderBy('name'),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    });
  }

  // Add category
  Future<bool> addCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.createDocument(
        collection: 'categories',
        docId: category.id,
        data: category.toJson(),
      );
      
      _categories.add(category);
      _categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add category: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update category
  Future<bool> updateCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.updateDocument(
        collection: 'categories',
        docId: category.id,
        data: category.copyWith(updatedAt: DateTime.now()).toJson(),
      );
      
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        _categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update category: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if category has products
      final productsSnapshot = await _firebaseService.firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .limit(1)
          .get();

      if (productsSnapshot.docs.isNotEmpty) {
        _errorMessage = 'Cannot delete category with existing products';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get category to delete images
      final category = _categories.firstWhere((c) => c.id == categoryId);
      
      // Delete category icon/image from storage
      if (category.iconUrl != null) {
        try {
          await _firebaseService.deleteFile(category.iconUrl!);
        } catch (e) {
          debugPrint('Failed to delete icon: $e');
        }
      }
      
      if (category.imageUrl != null) {
        try {
          await _firebaseService.deleteFile(category.imageUrl!);
        } catch (e) {
          debugPrint('Failed to delete image: $e');
        }
      }
      
      // Delete category document
      await _firebaseService.deleteDocument(
        collection: 'categories',
        docId: categoryId,
      );
      
      _categories.removeWhere((c) => c.id == categoryId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete category: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Upload category icon
  Future<String?> uploadCategoryIcon(String categoryId, dynamic iconFile) async {
    try {
      final iconUrl = await _firebaseService.uploadFile(
        path: 'categories/$categoryId',
        file: iconFile,
        fileName: 'icon.png',
      );
      return iconUrl;
    } catch (e) {
      _errorMessage = 'Failed to upload icon: $e';
      notifyListeners();
      return null;
    }
  }

  // Upload category image
  Future<String?> uploadCategoryImage(String categoryId, dynamic imageFile) async {
    try {
      final imageUrl = await _firebaseService.uploadFile(
        path: 'categories/$categoryId',
        file: imageFile,
        fileName: 'image.jpg',
      );
      return imageUrl;
    } catch (e) {
      _errorMessage = 'Failed to upload image: $e';
      notifyListeners();
      return null;
    }
  }

  // Toggle category active status
  Future<bool> toggleCategoryStatus(String categoryId) async {
    try {
      final category = _categories.firstWhere((c) => c.id == categoryId);
      final updatedCategory = category.copyWith(
        isActive: !category.isActive,
        updatedAt: DateTime.now(),
      );
      
      return await updateCategory(updatedCategory);
    } catch (e) {
      _errorMessage = 'Failed to toggle category status: $e';
      notifyListeners();
      return false;
    }
  }

  // Reorder categories
  Future<bool> reorderCategories(int oldIndex, int newIndex) async {
    try {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      
      final category = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, category);
      
      // Update sort orders in batch
      await _firebaseService.batchWrite((batch) {
        for (int i = 0; i < _categories.length; i++) {
          final categoryRef = _firebaseService.firestore
              .collection('categories')
              .doc(_categories[i].id);
          
          batch.update(categoryRef, {
            'sortOrder': i,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to reorder categories: $e';
      notifyListeners();
      return false;
    }
  }

  // Get category by ID
  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Update product count for category
  Future<void> updateProductCount(String categoryId, int count) async {
    try {
      await _firebaseService.updateDocument(
        collection: 'categories',
        docId: categoryId,
        data: {'productCount': count},
      );
      
      final index = _categories.indexWhere((c) => c.id == categoryId);
      if (index != -1) {
        _categories[index] = _categories[index].copyWith(productCount: count);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to update product count: $e');
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}