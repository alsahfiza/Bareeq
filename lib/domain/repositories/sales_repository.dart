import '../entities/sale_entity.dart';

abstract class SalesRepository {
  Future<List<SaleEntity>> getSales({
    DateTime? from,
    DateTime? to,
  });
}
