import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../domain/policies/data_consistency_policy.dart';

final dataConsistencyProvider =
    FutureProvider<List<DataConsistencyIssue>>((ref) async {
  final products = await ref.read(getProductsProvider).call();
  final inventory = await ref.read(getInventoryProvider).call();
  final sales = await ref.read(getSalesProvider).call();

  return DataConsistencyPolicy.check(
    products: products,
    inventory: inventory,
    sales: sales,
  );
});
