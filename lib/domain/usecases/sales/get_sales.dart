import '../../entities/sale_entity.dart';
import '../../repositories/sale_repository.dart';

class GetSales {
  final SaleRepository repo;

  GetSales(this.repo);

  Future<List<SaleEntity>> call({
    DateTime? from,
    DateTime? to,
  }) {
    return repo.getSales(from: from, to: to);
  }
}
