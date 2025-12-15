class BannerModel {
  final String id;
  final String imageUrl;
  final String type; // category | product
  final String targetId;
  final bool isActive;
  final int order;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.targetId,
    required this.isActive,
    required this.order,
  });

  factory BannerModel.fromMap(String id, Map<String, dynamic> data) {
    return BannerModel(
      id: id,
      imageUrl: data['imageUrl'],
      type: data['type'],
      targetId: data['targetId'],
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'type': type,
      'targetId': targetId,
      'isActive': isActive,
      'order': order,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
