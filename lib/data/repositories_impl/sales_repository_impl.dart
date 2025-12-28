import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/firestore/sale_firestore_datasource.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleFirestoreDatasource datasource;

  SaleRepositoryImpl(this.datasource);

  @override
  Future<List<SaleEntity>> getSales({
    DateTime? from,
    DateTime? to,
  }) async {
    final models = await datasource.getAll(from: from, to: to);
    return models.map((m) => m.toEntity()).toList();
  }
}
