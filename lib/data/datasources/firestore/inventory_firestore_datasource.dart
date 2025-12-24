import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/inventory_model.dart';

class InventoryFirestoreDatasource {
  final FirebaseFirestore _firestore;

  InventoryFirestoreDatasource(this._firestore);

  Future<List<InventoryModel>> getInventory() async {
    final snapshot = await _firestore
        .collection('inventory')
        .get();

    return snapshot.docs
        .map((doc) => InventoryModel.fromFirestore(doc))
        .toList();
  }

  Future<void> updateInventory(
    String inventoryId,
    InventoryModel inventory,
  ) async {
    await _firestore
        .collection('inventory')
        .doc(inventoryId)
        .set(
          inventory.toFirestore(),
          SetOptions(merge: true),
        );
  }
}
