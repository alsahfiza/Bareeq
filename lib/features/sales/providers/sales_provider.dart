import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/domain/entities/sale_entity.dart';
import 'lib/core/config/usecase_providers.dart';

sealed class SalesState {}
class SalesLoading extends SalesState {}
class SalesReady extends SalesState {
  final List<SaleEntity> sales;
  SalesReady(this.sales);
}
class SalesError extends SalesState {
  final String message;
  SalesError(this.message);
}

final salesProvider =
    StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  return SalesNotifier(ref);
});

class SalesNotifier extends StateNotifier<SalesState> {
  final Ref ref;

  SalesNotifier(this.ref) : super(SalesLoading()) {
    load();
  }

  Future<void> load({DateTime? from, DateTime? to}) async {
    try {
      final sales =
          await ref.read(getSalesProvider).call(from: from, to: to);
      state = SalesReady(sales);
    } catch (e) {
      state = SalesError(e.toString());
    }
  }
}
