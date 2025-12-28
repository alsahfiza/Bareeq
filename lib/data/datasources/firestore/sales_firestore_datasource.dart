import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sale_model.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../domain/repositories/sale_repository.dart';
import '../../../data/repositories_impl/sale_repository_impl.dart';
import '../../../domain/usecases/sales/get_sales.dart';
import '../../../core/config/firestore_providers.dart';
import '../../../core/config/repository_providers.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../data/datasources/firestore/sale_firestore_datasource.dart';


class SaleFirestoreDatasource {
  final FirebaseFirestore firestore;

  SaleFirestoreDatasource(this.firestore);

  Future<List<SaleModel>> getSales() async {
    final snapshot = await firestore.collection('sales').get();
    return snapshot.docs
        .map((d) => SaleModel.fromFirestore(d))
        .toList();
  }
}
