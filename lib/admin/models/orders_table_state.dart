class OrdersTableState {
  final String search;
  final String status;

  OrdersTableState({
    required this.search,
    required this.status,
  });

  OrdersTableState copyWith({
    String? search,
    String? status,
  }) {
    return OrdersTableState(
      search: search ?? this.search,
      status: status ?? this.status,
    );
  }
}
