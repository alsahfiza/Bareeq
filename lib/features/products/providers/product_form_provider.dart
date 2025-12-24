import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../core/config/audit_providers.dart';

class ProductFormState {
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final double price;
  final double cost;
  final bool isActive;
  final bool submitting;
  final String? error;

  const ProductFormState({
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.price,
    required this.cost,
    required this.isActive,
    required this.submitting,
    this.error,
  });

  ProductFormState copyWith({
    String? name,
    String? sku,
    String? barcode,
    String? category,
    double? price,
    double? cost,
    bool? isActive,
    bool? submitting,
    String? error,
  }) {
    return ProductFormState(
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      isActive: isActive ?? this.isActive,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

  static ProductFormState empty() {
    return const ProductFormState(
      name: '',
      sku: '',
      barcode: '',
      category: '',
      price: 0,
      cost: 0,
      isActive: true,
      submitting: false,
    );
  }

  static ProductFormState from(ProductEntity p) {
    return ProductFormState(
      name: p.name,
      sku: p.sku,
      barcode: p.barcode,
      category: p.category,
      price: p.price,
      cost: p.cost,
      isActive: p.isActive,
      submitting: false,
    );
  }
}

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, ProductFormState>((ref) {
  return ProductFormNotifier(ref);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Ref ref;
  ProductEntity? _editing;

  ProductFormNotifier(this.ref) : super(ProductFormState.empty());

  void loadForEdit(ProductEntity product) {
    _editing = product;
    state = ProductFormState.from(product);
  }

  void updateName(String v) => state = state.copyWith(name: v);
  void updateSku(String v) => state = state.copyWith(sku: v);
  void updateBarcode(String v) => state = state.copyWith(barcode: v);
  void updateCategory(String v) => state = state.copyWith(category: v);
  void updatePrice(double v) => state = state.copyWith(price: v);
  void updateCost(double v) => state = state.copyWith(cost: v);
  void toggleActive(bool v) => state = state.copyWith(isActive: v);

  Future<void> submit() async {
    state = state.copyWith(submitting: true, error: null);

    try {
      if (_editing == null) {
        final product = ProductEntity(
          id: '',
          name: state.name,
          sku: state.sku,
          barcode: state.barcode,
          category: state.category,
          price: state.price,
          cost: state.cost,
          isActive: state.isActive,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await ref.read(createProductProvider).call(product);

        await ref.read(auditLogServiceProvider).log(
          action: 'CREATE',
          entity: 'product',
          entityId: product.sku,
          before: {},
          after: {
            'name': product.name,
            'sku': product.sku,
            'price': product.price,
            'cost': product.cost,
            'isActive': product.isActive,
          },
        );
      } else {
        final updated = _editing!.copyWith(
          name: state.name,
          sku: state.sku,
          barcode: state.barcode,
          category: state.category,
          price: state.price,
          cost: state.cost,
          isActive: state.isActive,
          updatedAt: DateTime.now(),
        );

        await ref.read(updateProductProvider).call(updated);

        await ref.read(auditLogServiceProvider).log(
          action: 'UPDATE',
          entity: 'product',
          entityId: updated.id,
          before: {
            'price': _editing!.price,
            'cost': _editing!.cost,
            'isActive': _editing!.isActive,
          },
          after: {
            'price': updated.price,
            'cost': updated.cost,
            'isActive': updated.isActive,
          },
        );
      }

      state = ProductFormState.empty();
      _editing = null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}
