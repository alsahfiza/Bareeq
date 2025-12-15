import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analytics_model.dart';

class AnalyticsService {
  final _db = FirebaseFirestore.instance;

  Stream<SalesAnalytics> getAnalytics() {
    return _db.collection('orders').snapshots().map((snapshot) {
      double totalRevenue = 0;
      double todayRevenue = 0;
      int totalOrders = 0;
      final Map<String, int> productCounter = {};

      final today = DateTime.now();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        if (data['status'] != 'accepted' &&
            data['status'] != 'delivered') {
          continue;
        }

        final double total = (data['total'] as num).toDouble();
        final DateTime createdAt =
            DateTime.parse(data['createdAt']);

        totalOrders++;
        totalRevenue += total;

        if (createdAt.year == today.year &&
            createdAt.month == today.month &&
            createdAt.day == today.day) {
          todayRevenue += total;
        }

        for (final item in List<Map<String, dynamic>>.from(
            data['items'])) {
          final name = item['name'];
          final qty = item['qty'] as int;
          productCounter[name] =
              (productCounter[name] ?? 0) + qty;
        }
      }

      return SalesAnalytics(
        totalRevenue: totalRevenue,
        totalOrders: totalOrders,
        todayRevenue: todayRevenue,
        topProducts: productCounter,
      );
    });
  }
}
