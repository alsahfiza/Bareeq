import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueService {
  final orders = FirebaseFirestore.instance.collection("orders");

  Future<double> getTotalRevenue() async {
    final snap = await orders.get();
    double total = 0.0;

    for (var doc in snap.docs) {
      total += double.tryParse(doc["total"].toString()) ?? 0.0;
    }
    return total;
  }

  Future<Map<int, double>> getMonthlyRevenue() async {
    final snap = await orders.get();
    Map<int, double> revenue = {};

    for (var doc in snap.docs) {
      DateTime date = (doc["created_at"] as Timestamp).toDate();
      double total = double.tryParse(doc["total"].toString()) ?? 0;

      revenue.update(date.month,
          (value) => value + total, ifAbsent: () => total);
    }
    return revenue;
  }
}
