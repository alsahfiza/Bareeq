class CategoryModel {
  final String id;
  final String name;
  final bool isActive;
  final int order;

  CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.order,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'],
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isActive': isActive,
      'order': order,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
