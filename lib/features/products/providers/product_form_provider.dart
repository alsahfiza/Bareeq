import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, ProductFormState>(
  (ref) => ProductFormNotifier(),
);

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  ProductFormNotifier() : super(ProductFormState.initial());

  void updateName(String v) =>
      state = state.copyWith(name: v);

  void updateSku(String v) =>
      state = state.copyWith(sku: v);

  void updateBarcode(String v) =>
      state = state.copyWith(barcode: v);

  void updateCategory(String v) =>
      state = state.copyWith(category: v);

  void updatePrice(double v) =>
      state = state.copyWith(price: v);

  void updateCost(double v) =>
      state = state.copyWith(cost: v);

  void toggleActive(bool v) =>
      state = state.copyWith(isActive: v);

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
      // persistence later
      state = state.copyWith(submitting: false);
    } catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.toString(),
      );
    }
  }
}

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
    required this.error,
  });

  factory ProductFormState.initial() => const ProductFormState(
        name: '',
        sku: '',
        barcode: '',
        category: '',
        price: 0,
        cost: 0,
        isActive: true,
        submitting: false,
        error: null,
      );
  factory ProductFormState.empty() => ProductFormState.initial();
  
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
}
