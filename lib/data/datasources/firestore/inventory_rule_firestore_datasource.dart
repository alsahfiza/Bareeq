import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/inventory_rule_model.dart';

class InventoryRuleFirestoreDatasource {
  final FirebaseFirestore firestore;

  InventoryRuleFirestoreDatasource(this.firestore);

  Future<int> getDefaultMinimumStock() async {
    final doc =
        await firestore.collection('settings').doc('inventory').get();

    final data = doc.data();
    return data == null ? 10 : data['defaultMinimumStock'] ?? 10;
  }

  Future<void> setDefaultMinimumStock(int value) async {
    await firestore.collection('settings').doc('inventory').set({
      'defaultMinimumStock': value,
    }, SetOptions(merge: true));
  }

  Future<List<InventoryRuleModel>> getRules() async {
    final snapshot =
        await firestore.collection('inventory_rules').get();

    return snapshot.docs
        .map((d) => InventoryRuleModel.fromFirestore(d))
        .toList();
  }

  Future<void> upsertRule(InventoryRuleModel model) async {
    await firestore
        .collection('inventory_rules')
        .doc(model.productId)
        .set(model.toFirestore());
  }
}
