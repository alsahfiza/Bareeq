import 'package:uuid/uuid.dart';
import '../../../domain/entities/data_snapshot_entity.dart';
import '../../../core/config/usecase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnapshotBuilder {
  final Ref ref;
  SnapshotBuilder(this.ref);

  Future<DataSnapshotEntity> build(
    SnapshotType type,
    String userId,
  ) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    Map<String, dynamic> data;

    switch (type) {
      case SnapshotType.products:
        final products = await ref.read(getProductsProvider).call();
        data = {
          'count': products.length,
        };
        break;

      case SnapshotType.inventoryTotals:
        final inventory = await ref.read(getInventoryProvider).call();
        final total = inventory.fold<int>(
          0,
          (sum, i) => sum + i.quantity,
        );
        data = {
          'totalQuantity': total,
        };
        break;

      case SnapshotType.salesTotals:
        final sales = await ref.read(getSalesProvider).call();
        final revenue = sales.fold<double>(
          0,
          (sum, s) => sum + s.total,
        );
        data = {
          'totalRevenue': revenue,
        };
        break;
    }

    return DataSnapshotEntity(
      id: id,
      type: type,
      createdAt: now,
      createdBy: userId,
      data: data,
    );
  }
}
