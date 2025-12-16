class BranchModel {
  final String id;
  final String name;
  final bool isActive;

  BranchModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory BranchModel.fromMap(String id, Map<String, dynamic> data) {
    return BranchModel(
      id: id,
      name: data['name'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isActive': isActive,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
