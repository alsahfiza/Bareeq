import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/firestore/inventory_firestore_datasource.dart';
import '../../data/repositories_impl/inventory_repository_impl.dart';
import '../../domain/usecases/inventory/get_inventory.dart';
import '../../domain/usecases/inventory/adjust_inventory.dart';

final inventoryRepositoryProvider = Provider(
  (ref) => InventoryRepositoryImpl(
    InventoryFirestoreDatasource(FirebaseFirestore.instance),
  ),
);

final getInventoryProvider =
    Provider((ref) => GetInventory(ref.read(inventoryRepositoryProvider)));

final adjustInventoryProvider =
    Provider((ref) => AdjustInventory(ref.read(inventoryRepositoryProvider)));
