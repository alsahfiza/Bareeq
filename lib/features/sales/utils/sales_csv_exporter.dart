import '../../../domain/entities/sale_entity.dart';

class SalesCsvExporter {
  static String export(List<SaleEntity> sales) {
    final buffer = StringBuffer();
    buffer.writeln('id,productId,quantity,total,profit,date');

    for (final s in sales) {
      buffer.writeln(
        '${s.id},${s.productId},${s.quantity},${s.total},${s.profit},${s.createdAt.toIso8601String()}',
      );
    }
    return buffer.toString();
  }
}
