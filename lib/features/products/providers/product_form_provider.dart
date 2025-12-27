import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/audit_log_service.dart';
import '../../../core/config/audit_providers.dart';
import '../../../domain/entities/product_entity.dart';

class ProductFormNotifier extends StateNotifier<void> {
  final Ref ref;

  ProductFormNotifier(this.ref) : super(null);

  Future<void> save(ProductEntity updated) async {
    // existing save logic stays untouched

    await ref.read(auditLogServiceProvider).log(
      action: 'save_product',
      before: {},
      after: {
        'id': updated.id,
        'name': updated.name,
        'price': updated.price,
      },
    );
  }
}
