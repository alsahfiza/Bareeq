import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemHealth {
  final int products;
  final int inventory;
  final int sales;
  final int audits;

  const SystemHealth({
    required this.products,
    required this.inventory,
    required this.sales,
    required this.audits,
  });
}

final systemHealthProvider = FutureProvider<SystemHealth>((ref) async {
  // TEMP static values until real usecases exist
  return const SystemHealth(
    products: 0,
    inventory: 0,
    sales: 0,
    audits: 0,
  );
});
