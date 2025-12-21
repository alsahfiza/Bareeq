import 'package:cloud_firestore/cloud_firestore.dart';
// ==================== RECEIPT GENERATION ====================

class ReceiptGenerator {
  static String generateReceiptText(SaleModel sale, CustomerModel? customer) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('           بريق BAREEQ');
    buffer.writeln('    للبلاستيك ومواد النظافة');
    buffer.writeln('   Plastics & Cleaning Supplies');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    
    // Sale Info
    buffer.writeln('Sale #: ${sale.saleNumber}');
    buffer.writeln('Date: ${_formatDate(sale.saleDate)}');
    buffer.writeln('Time: ${_formatTime(sale.saleDate)}');
    buffer.writeln('Cashier: ${sale.cashierName}');
    if (customer != null) {
      buffer.writeln('Customer: ${customer.name}');
      buffer.writeln('Points: ${customer.loyaltyPoints}');
    }
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('');
    
    // Items
    buffer.writeln('ITEMS:');
    buffer.writeln('');
    for (final item in sale.items) {
      buffer.writeln('${item.productName}');
      buffer.writeln('  ${item.quantity} x SAR ${item.unitPrice.toStringAsFixed(2)} = SAR ${item.total.toStringAsFixed(2)}');
    }
    buffer.writeln('');
    buffer.writeln('───────────────────────────────────────');
    
    // Totals
    buffer.writeln('Subtotal:        SAR ${sale.subtotal.toStringAsFixed(2)}');
    if (sale.discount > 0) {
      buffer.writeln('Discount:        SAR ${sale.discount.toStringAsFixed(2)}');
    }
    buffer.writeln('Tax (15%):       SAR ${sale.tax.toStringAsFixed(2)}');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('TOTAL:           SAR ${sale.total.toStringAsFixed(2)}');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    
    // Payment
    buffer.writeln('Payment: ${sale.paymentMethod.displayName}');
    buffer.writeln('');
    
    // Loyalty Points Earned
    if (customer != null) {
      final pointsEarned = CustomerModel.calculatePoints(sale.total);
      buffer.writeln('Points Earned: +$pointsEarned');
      buffer.writeln('Total Points: ${customer.loyaltyPoints + pointsEarned}');
      buffer.writeln('');
    }
    
    // Footer
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('      Thank you! شكراً لزيارتكم      ');
    buffer.writeln('        Visit us again soon!         ');
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('');
    buffer.writeln('VAT #: 123456789012345'); // Add your VAT number
    buffer.writeln('Tel: +966 XX XXX XXXX'); // Add your phone
    buffer.writeln('');

    return buffer.toString();
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}