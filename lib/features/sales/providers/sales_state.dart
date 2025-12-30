import '../../../domain/entities/sale_entity.dart';

class SalesState {
  final bool loading;
  final List<SaleEntity> all;
  final int page;
  final int pageSize;

  const SalesState({
    required this.loading,
    required this.all,
    required this.page,
    required this.pageSize,
  });

  factory SalesState.initial() {
    return const SalesState(
      loading: false,
      all: [],
      page: 0,
      pageSize: 10,
    );
  }

  SalesState copyWith({
    bool? loading,
    List<SaleEntity>? all,
    int? page,
    int? pageSize,
  }) {
    return SalesState(
      loading: loading ?? this.loading,
      all: all ?? this.all,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  List<SaleEntity> get visible {
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  double get totalRevenue =>
      all.fold(0, (sum, s) => sum + s.revenue);

  double get totalProfit =>
      all.fold(0, (sum, s) => sum + s.profit);
}
