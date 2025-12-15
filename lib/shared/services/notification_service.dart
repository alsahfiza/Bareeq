import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'fcmToken': token,
    });
  }
}
