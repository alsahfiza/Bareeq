import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/dashboard_kpi.dart';

final dashboardKpiProvider = Provider<DashboardKpi>((ref) {
  // TEMP: static values (Firestore later)
  return const DashboardKpi(
    totalSales: 48988.07,
    salesReturn: 16478.15,
    totalPurchase: 24145.78,
    purchaseReturn: 18458.74,
    totalProfit: 8458.79,
    invoiceDue: 48988.78,
    totalExpenses: 8980.09,
    totalPaymentReturns: 78458.79,
  );
});
