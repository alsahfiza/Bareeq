import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/products/create_product.dart';
import '../../domain/usecases/products/update_product.dart';
import '../../domain/usecases/products/get_products.dart';
import '../../domain/usecases/inventory/get_inventory.dart';
import '../../domain/usecases/inventory/adjust_inventory.dart';
import '../../domain/usecases/sales/get_sales.dart';
import '../../domain/usecases/users/create_user.dart';
import '../../domain/usecases/users/get_users.dart';
import '../../domain/usecases/audit/log_action.dart';
import 'repository_providers.dart';

final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productRepositoryProvider));
});

final createProductProvider = Provider<CreateProduct>((ref) {
  return CreateProduct(ref.read(productRepositoryProvider));
});

final updateProductProvider = Provider<UpdateProduct>((ref) {
  return UpdateProduct(ref.read(productRepositoryProvider));
});

final getInventoryProvider = Provider<GetInventory>((ref) {
  return GetInventory(ref.read(inventoryRepositoryProvider));
});

final adjustInventoryProvider = Provider<AdjustInventory>((ref) {
  return AdjustInventory(ref.read(inventoryRepositoryProvider));
});

final getSalesProvider = Provider<GetSales>((ref) {
  return GetSales(ref.read(salesRepositoryProvider));
});

final getUsersProvider = Provider<GetUsers>((ref) {
  return GetUsers(ref.read(userRepositoryProvider));
});

final createUserProvider = Provider<CreateUser>((ref) {
  return CreateUser(ref.read(userRepositoryProvider));
});

final logActionProvider = Provider<LogAction>((ref) {
  return LogAction(ref.read(auditRepositoryProvider));
});
