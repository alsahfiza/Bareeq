import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_settings_model.dart';

class SettingsService {
  final _ref =
      FirebaseFirestore.instance.collection('settings').doc('app');

  Stream<AppSettings> getSettings() {
    return _ref.snapshots().map(
          (doc) => AppSettings.fromMap(doc.data()),
        );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _ref.set(settings.toMap());
  }
}
