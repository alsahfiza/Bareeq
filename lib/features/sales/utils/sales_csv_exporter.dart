import '../../../domain/entities/sale_entity.dart';

class SalesCsvExporter {
  static String export(List<SaleEntity> sales) {
    final buffer = StringBuffer();
    buffer.writeln('Date,Total,Profit');

    for (final s in sales) {
      buffer.writeln(
        '${s.createdAt.toIso8601String()},${s.total},${s.profit}',
      );
    }

    return buffer.toString();
  }
}
