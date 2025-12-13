class CategoryModel {
  final String id;
  final String nameAr;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.imageUrl,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      nameAr: map['name_ar'] ?? map['name'] ?? map['title'] ?? '',
      imageUrl: map['image_url'] ?? map['image'] ?? map['photo'] ?? '',
    );
  }
}
