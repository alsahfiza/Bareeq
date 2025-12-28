import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/dashboard_kpi.dart';

class DashboardFirestoreDatasource {
  final FirebaseFirestore firestore;

  DashboardFirestoreDatasource(this.firestore);

  Future<DashboardKpi> loadKpis() async {
    final products = await firestore.collection('products').count().get();
    final inventory = await firestore.collection('inventory').count().get();
    final users = await firestore.collection('users').count().get();
    final sales = await firestore.collection('sales').count().get();

    return DashboardKpi(
      productsCount: products.count ?? 0,
      inventoryCount: inventory.count ?? 0,
      usersCount: users.count ?? 0,
      salesCount: sales.count ?? 0,
      totalRevenue: 0.0, // intentionally stubbed
    );
  }
}
