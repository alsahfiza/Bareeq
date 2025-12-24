import '../../entities/dashboard_kpi_entity.dart';
import '../../repositories/sales_repository.dart';
import '../../repositories/inventory_repository.dart';

class GetDashboardKpis {
  final SalesRepository salesRepository;
  final InventoryRepository inventoryRepository;

  GetDashboardKpis({
    required this.salesRepository,
    required this.inventoryRepository,
  });

  Future<DashboardKpiEntity> call({
    required DateTime from,
    required DateTime to,
  }) async {
    final currentSales =
        await salesRepository.getSales(from: from, to: to);

    final duration = to.difference(from);
    final prevFrom = from.subtract(duration);
    final prevTo = to.subtract(duration);

    final previousSales =
        await salesRepository.getSales(from: prevFrom, to: prevTo);

    final inventory = await inventoryRepository.getInventory();

    double currentRevenue = 0;
    double currentProfit = 0;

    for (final s in currentSales) {
      currentRevenue += s.total;
      currentProfit += s.profit;
    }

    double prevRevenue = 0;
    double prevProfit = 0;

    for (final s in previousSales) {
      prevRevenue += s.total;
      prevProfit += s.profit;
    }

    double trend(double current, double previous) {
      if (previous == 0) return 0;
      return ((current - previous) / previous) * 100;
    }

    final lowStock =
        inventory.where((i) => i.quantity <= 5).length;

    return DashboardKpiEntity(
      totalSales: currentSales.length.toDouble(),
      totalRevenue: currentRevenue,
      totalProfit: currentProfit,
      lowStockCount: lowStock,
      salesTrend: trend(
        currentSales.length.toDouble(),
        previousSales.length.toDouble(),
      ),
      revenueTrend: trend(currentRevenue, prevRevenue),
      profitTrend: trend(currentProfit, prevProfit),
    );
  }
}
