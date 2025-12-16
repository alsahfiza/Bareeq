import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/branch_inventory_model.dart';

class BranchInventoryService {
  final _ref = FirebaseFirestore.instance.collection('inventory');

  Stream<List<BranchInventory>> getInventoryByBranch(String branchId) {
    return _ref
        .where('branchId', isEqualTo: branchId)
        .snapshots()
        .map((s) => s.docs
            .map((d) => BranchInventory.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> setStock({
    required String branchId,
    required String productId,
    required int stock,
  }) async {
    final q = await _ref
        .where('branchId', isEqualTo: branchId)
        .where('productId', isEqualTo: productId)
        .get();

    if (q.docs.isEmpty) {
      await _ref.add({
        'branchId': branchId,
        'productId': productId,
        'stock': stock,
      });
    } else {
      await _ref.doc(q.docs.first.id).update({'stock': stock});
    }
  }
}
