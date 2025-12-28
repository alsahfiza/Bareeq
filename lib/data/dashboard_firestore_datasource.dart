import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/dashboard_kpi.dart';

class DashboardFirestoreDatasource {
  final FirebaseFirestore firestore;

  DashboardFirestoreDatasource(this.firestore);

  Future<DashboardKpi> loadKpis() async {
    final productsSnap = await firestore.collection('products').get();
    final inventorySnap = await firestore.collection('inventory').get();
    final salesSnap = await firestore.collection('sales').get();

    double revenue = 0;
    DateTime? lastSale;

    for (final doc in salesSnap.docs) {
      final data = doc.data();
      if (data['total'] is num) {
        revenue += (data['total'] as num).toDouble();
      }
      final ts = data['updatedAt'];
      if (ts is Timestamp) {
        final d = ts.toDate();
        if (lastSale == null || d.isAfter(lastSale)) {
          lastSale = d;
        }
      }
    }

    DateTime? _latest(QuerySnapshot snap) {
      DateTime? last;
      for (final d in snap.docs) {
        final ts = d['updatedAt'];
        if (ts is Timestamp) {
          final dt = ts.toDate();
          if (last == null || dt.isAfter(last)) {
            last = dt;
          }
        }
      }
      return last;
    }

    return DashboardKpi(
      productsCount: productsSnap.size,
      inventoryCount: inventorySnap.size,
      salesCount: salesSnap.size,
      totalRevenue: revenue,
      lastProductUpdate: _latest(productsSnap),
      lastInventoryUpdate: _latest(inventorySnap),
      lastSaleUpdate: lastSale,
    );
  }
}
