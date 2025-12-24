import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/system_settings_model.dart';

class SystemSettingsFirestoreDatasource {
  final FirebaseFirestore firestore;

  SystemSettingsFirestoreDatasource(this.firestore);

  Future<SystemSettingsModel> get() async {
    final doc =
        await firestore.collection('settings').doc('system').get();

    final data = doc.data();
    if (data == null) {
      return SystemSettingsModel(
        currencyCode: 'USD',
        dateFormat: 'yyyy-MM-dd',
        defaultMinimumStock: 10,
      );
    }

    return SystemSettingsModel.fromMap(data);
  }

  Future<void> update(SystemSettingsModel model) async {
    await firestore
        .collection('settings')
        .doc('system')
        .set(model.toMap(), SetOptions(merge: true));
  }
}
