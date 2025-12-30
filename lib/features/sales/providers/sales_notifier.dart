import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sales_state.dart';
import '../../../domain/entities/sale_entity.dart';

class SalesNotifier extends StateNotifier<SalesState> {
  SalesNotifier() : super(SalesState.initial()) {
    _loadStub();
  }

  Future<void> _loadStub() async {
    state = state.copyWith(loading: true);

    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      loading: false,
      all: List.generate(
        25,
        (i) => SaleEntity(
          id: '$i',
          productName: 'Product ${i + 1}',
          quantity: (i % 5) + 1,
          price: 15 + i,
          cost: 8 + (i / 2),
          date: DateTime.now().subtract(Duration(days: i)),
        ),
      ),
    );
  }

  void nextPage() {
    final maxPage = (state.all.length / state.pageSize).ceil() - 1;
    if (state.page < maxPage) {
      state = state.copyWith(page: state.page + 1);
    }
  }

  void prevPage() {
    if (state.page > 0) {
      state = state.copyWith(page: state.page - 1);
    }
  }
}
