class ProductSalesRank {
  final String productId;
  final int quantity;
  final double revenue;

  const ProductSalesRank({
    required this.productId,
    required this.quantity,
    required this.revenue,
  });
}

class StoreSalesSummary {
  final String storeId;
  final double revenue;

  const StoreSalesSummary({
    required this.storeId,
    required this.revenue,
  });
}

class TimeSalesBucket {
  final String label;
  final double revenue;

  const TimeSalesBucket({
    required this.label,
    required this.revenue,
  });
}
