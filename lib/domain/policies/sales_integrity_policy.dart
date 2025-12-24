import '../entities/sale_entity.dart';

class SalesIntegrityPolicy {
  static const int largeQuantityThreshold = 50;

  static bool isNegativeProfit(SaleEntity sale) {
    return sale.profit < 0;
  }

  static bool isLargeQuantity(SaleEntity sale) {
    return sale.quantity >= largeQuantityThreshold;
  }
}
