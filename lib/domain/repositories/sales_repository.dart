import '../entities/sale_entity.dart';

abstract class SaleRepository {
  Future<List<SaleEntity>> getSales({
    DateTime? from,
    DateTime? to,
  });
}
