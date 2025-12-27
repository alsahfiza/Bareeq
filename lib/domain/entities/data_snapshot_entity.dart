enum SnapshotType {
  products,
  inventoryTotals,
  salesTotals,
}

class DataSnapshotEntity {
  final String id;
  final SnapshotType type;
  final DateTime createdAt;
  final String createdBy;
  final Map<String, dynamic> data;

  const DataSnapshotEntity({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    required this.data,
  });
}
