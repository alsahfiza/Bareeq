import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/config/product_providers.dart';
import '../../../domain/usecases/products/save_product.dart';
import '../../../domain/usecases/products/get_products.dart';

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, ProductFormState>(
  (ref) => ProductFormNotifier(ref),
);

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Ref ref;

  ProductFormNotifier(this.ref) : super(ProductFormState.initial());

  void updateName(String v) => state = state.copyWith(name: v);
  void updateSku(String v) => state = state.copyWith(sku: v);
  void updateBarcode(String v) => state = state.copyWith(barcode: v);
  void updateCategory(String v) => state = state.copyWith(category: v);
  void updatePrice(double v) => state = state.copyWith(price: v);
  void updateCost(double v) => state = state.copyWith(cost: v);
  void toggleActive(bool v) => state = state.copyWith(isActive: v);

  void loadForEdit(ProductEntity p) {
    state = state.copyWith(
      name: p.name,
      sku: p.sku,
      barcode: p.barcode,
      category: p.category,
      price: p.price,
      cost: p.cost,
      isActive: p.isActive,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(submitting: true, error: null);

    try {
      final now = DateTime.now();

      final product = ProductEntity(
        id: const Uuid().v4(),
        name: state.name,
        sku: state.sku,
        barcode: state.barcode,
        category: state.category,
        price: state.price,
        cost: state.cost,
        isActive: state.isActive,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(saveProductProvider).call(product);
      state = ProductFormState.initial();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}

class ProductFormState {
  final ProductEntity? product;

  const ProductFormState._(this.product);

  factory ProductFormState.empty() => const ProductFormState._(null);
  factory ProductFormState.edit(ProductEntity product) =>
      ProductFormState._(product);
}