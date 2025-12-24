import 'sales_intelligence_models.dart';

class SalesIntelligenceCsv {
  static String productRanks(List<ProductSalesRank> data) {
    final b = StringBuffer('productId,quantity,revenue\n');
    for (final r in data) {
      b.writeln('${r.productId},${r.quantity},${r.revenue}');
    }
    return b.toString();
  }

  static String storeSummary(List<StoreSalesSummary> data) {
    final b = StringBuffer('storeId,revenue\n');
    for (final s in data) {
      b.writeln('${s.storeId},${s.revenue}');
    }
    return b.toString();
  }

  static String timeBuckets(List<TimeSalesBucket> data) {
    final b = StringBuffer('period,revenue\n');
    for (final t in data) {
      b.writeln('${t.label},${t.revenue}');
    }
    return b.toString();
  }
}
