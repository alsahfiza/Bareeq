import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/inventory_model.dart';
import '../../models/inventory_adjustment_model.dart';

class InventoryFirestoreDatasource {
  final FirebaseFirestore firestore;
  InventoryFirestoreDatasource(this.firestore);

  Future<List<InventoryModel>> getAll() async {
    final snap = await firestore.collection('inventory').get();
    return snap.docs.map(InventoryModel.fromFirestore).toList();
  }

  Future<void> adjustStock({
    required String productId,
    required int delta,
  }) async {
    final inventoryRef = firestore.collection('inventory').doc(productId);
    final adjustmentsRef = firestore.collection('inventory_adjustments');

    await firestore.runTransaction((tx) async {
      final snap = await tx.get(inventoryRef);

      final before = snap.exists ? (snap['quantity'] ?? 0) : 0;
      final after = before + delta;

      tx.set(
        inventoryRef,
        {
          'quantity': after,
          'updatedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );

      tx.set(
        adjustmentsRef.doc(),
        InventoryAdjustmentModel.create(
          productId: productId,
          delta: delta,
          before: before,
          after: after,
        ),
      );
    });
  }
}
