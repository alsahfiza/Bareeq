import 'package:cloud_firestore/cloud_firestore.dart';


// ==================== PRODUCT MODEL ====================

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? costPrice;
  final int stock;
  final String? categoryId;
  final String? imageUrl;
  final List<String>? images;
  final String? barcode;
  final String? sku;
  final double? rating;
  final int? reviewCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.costPrice,
    this.stock = 0,
    this.categoryId,
    this.imageUrl,
    this.images,
    this.barcode,
    this.sku,
    this.rating,
    this.reviewCount,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Profit calculation
  double get profit => costPrice != null ? price - costPrice! : 0;
  double get profitMargin => costPrice != null ? ((profit / price) * 100) : 0;

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'costPrice': costPrice,
      'stock': stock,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'images': images,
      'barcode': barcode,
      'sku': sku,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convert to JSON (for general use)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'costPrice': costPrice,
      'stock': stock,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'images': images,
      'barcode': barcode,
      'sku': sku,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      costPrice: data['costPrice'] != null ? (data['costPrice']).toDouble() : null,
      stock: data['stock'] ?? 0,
      categoryId: data['categoryId'],
      imageUrl: data['imageUrl'],
      images: List<String>.from(data['images'] ?? []),
      barcode: data['barcode'],
      sku: data['sku'],
      rating: data['rating'] != null ? (data['rating']).toDouble() : null,
      reviewCount: data['reviewCount'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Create from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      costPrice: json['costPrice'] != null ? (json['costPrice']).toDouble() : null,
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'],
      imageUrl: json['imageUrl'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      barcode: json['barcode'],
      sku: json['sku'],
      rating: json['rating'] != null ? (json['rating']).toDouble() : null,
      reviewCount: json['reviewCount'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Copy with changes
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? costPrice,
    int? stock,
    String? categoryId,
    String? imageUrl,
    List<String>? images,
    String? barcode,
    String? sku,
    double? rating,
    int? reviewCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, stock: $stock)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ==================== CATEGORY MODEL ====================

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final int sortOrder;
  final bool isActive;
  final int productCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.sortOrder = 0,
    this.isActive = true,
    this.productCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'productCount': productCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'productCount': productCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      iconUrl: data['iconUrl'],
      sortOrder: data['sortOrder'] ?? 0,
      isActive: data['isActive'] ?? true,
      productCount: data['productCount'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      iconUrl: json['iconUrl'],
      sortOrder: json['sortOrder'] ?? 0,
      isActive: json['isActive'] ?? true,
      productCount: json['productCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Copy with changes
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? iconUrl,
    int? sortOrder,
    bool? isActive,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      productCount: productCount ?? this.productCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, productCount: $productCount)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ==================== EXTENSIONS ====================

extension ProductBarcode on ProductModel {
  String get barcodeDisplay => barcode ?? 'No barcode';

  bool hasBarcode() => barcode != null && barcode!.isNotEmpty;
}

class ProductWithBarcode {
  final ProductModel product;
  final String barcode;

  ProductWithBarcode({
    required this.product,
    required this.barcode,
  });
}