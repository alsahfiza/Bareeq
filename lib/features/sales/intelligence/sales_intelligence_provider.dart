import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../domain/entities/sale_entity.dart';
import 'sales_intelligence_models.dart';

enum TimeBucket { daily, weekly }

class SalesIntelligenceState {
  final List<ProductSalesRank> productRanks;
  final List<StoreSalesSummary> storeSummary;
  final List<TimeSalesBucket> timeBuckets;

  const SalesIntelligenceState({
    required this.productRanks,
    required this.storeSummary,
    required this.timeBuckets,
  });
}

final salesIntelligenceProvider =
    FutureProvider.family<SalesIntelligenceState, _Params>((ref, params) async {
  final sales = await ref.read(getSalesProvider).call(
        from: params.from,
        to: params.to,
      );

  final Map<String, ProductSalesRank> byProduct = {};
  final Map<String, double> byStore = {};
  final Map<String, double> byTime = {};

  for (final SaleEntity s in sales) {
    /// Product ranking
    byProduct.update(
      s.productId,
      (v) => ProductSalesRank(
        productId: v.productId,
        quantity: v.quantity + s.quantity,
        revenue: v.revenue + s.total,
      ),
      ifAbsent: () => ProductSalesRank(
        productId: s.productId,
        quantity: s.quantity,
        revenue: s.total,
      ),
    );

    /// Store summary (storeId encoded in sale id or metadata)
    final storeId = s.id.split('_').first;
    byStore[storeId] = (byStore[storeId] ?? 0) + s.total;

    /// Time buckets
    final key = params.bucket == TimeBucket.daily
        ? s.createdAt.toIso8601String().split('T').first
        : _weekKey(s.createdAt);

    byTime[key] = (byTime[key] ?? 0) + s.total;
  }

  final productRanks = byProduct.values.toList()
    ..sort((a, b) => b.revenue.compareTo(a.revenue));

  final storeSummary = byStore.entries
      .map((e) => StoreSalesSummary(storeId: e.key, revenue: e.value))
      .toList()
    ..sort((a, b) => b.revenue.compareTo(a.revenue));

  final timeBuckets = byTime.entries
      .map((e) => TimeSalesBucket(label: e.key, revenue: e.value))
      .toList()
    ..sort((a, b) => a.label.compareTo(b.label));

  return SalesIntelligenceState(
    productRanks: productRanks,
    storeSummary: storeSummary,
    timeBuckets: timeBuckets,
  );
});

class _Params {
  final DateTime from;
  final DateTime to;
  final TimeBucket bucket;

  const _Params({
    required this.from,
    required this.to,
    required this.bucket,
  });
}

String _weekKey(DateTime d) {
  final week = (d.day / 7).ceil();
  return '${d.year}-W$week';
}
