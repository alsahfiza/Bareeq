import '../../entities/sale_entity.dart';
import '../../repositories/sales_repository.dart';

class GetSales {
  final SalesRepository repository;

  GetSales(this.repository);

  Future<List<SaleEntity>> call({
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getSales(from: from, to: to);
  }
}
