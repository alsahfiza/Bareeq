import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../domain/policies/sales_integrity_policy.dart';
import 'sales_integrity_finding.dart';

final salesIntegrityProvider =
    FutureProvider<List<SalesIntegrityFinding>>((ref) async {
  final sales = await ref.read(getSalesProvider).call();

  final List<SalesIntegrityFinding> findings = [];

  for (final SaleEntity s in sales) {
    if (SalesIntegrityPolicy.isNegativeProfit(s)) {
      findings.add(
        SalesIntegrityFinding(
          saleId: s.id,
          productId: s.productId,
          quantity: s.quantity,
          profit: s.profit,
          issue: 'Negative profit',
        ),
      );
    }

    if (SalesIntegrityPolicy.isLargeQuantity(s)) {
      findings.add(
        SalesIntegrityFinding(
          saleId: s.id,
          productId: s.productId,
          quantity: s.quantity,
          profit: s.profit,
          issue: 'Unusually large quantity',
        ),
      );
    }
  }

  return findings;
});
