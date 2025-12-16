class BranchInventory {
  final String id;
  final String branchId;
  final String productId;
  final int stock;

  BranchInventory({
    required this.id,
    required this.branchId,
    required this.productId,
    required this.stock,
  });

  factory BranchInventory.fromMap(String id, Map<String, dynamic> data) {
    return BranchInventory(
      id: id,
      branchId: data['branchId'],
      productId: data['productId'],
      stock: data['stock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'productId': productId,
      'stock': stock,
    };
  }
}
