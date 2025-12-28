import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/firestore/sale_firestore_datasource.dart';
import '../../data/repositories_impl/sale_repository_impl.dart';
import '../../domain/usecases/sales/get_sales.dart';

final saleRepositoryProvider = Provider(
  (ref) => SaleRepositoryImpl(
    SaleFirestoreDatasource(FirebaseFirestore.instance),
  ),
);

final getSalesProvider =
    Provider((ref) => GetSales(ref.read(saleRepositoryProvider)));
