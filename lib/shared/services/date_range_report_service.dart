import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/date_range_report_model.dart';

class DateRangeReportService {
  final _db = FirebaseFirestore.instance;

  Future<DateRangeReport> getReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final snapshot = await _db
        .collection('orders')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: start.toIso8601String(),
        )
        .where(
          'createdAt',
          isLessThanOrEqualTo: end.toIso8601String(),
        )
        .get();

    int totalOrders = 0;
    double totalRevenue = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['status'] != 'accepted' &&
          data['status'] != 'delivered') {
        continue;
      }

      totalOrders++;
      totalRevenue += (data['total'] as num).toDouble();
    }

    return DateRangeReport(
      totalOrders: totalOrders,
      totalRevenue: totalRevenue,
    );
  }
}
