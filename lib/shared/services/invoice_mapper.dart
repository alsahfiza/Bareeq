import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_model.dart';

class InvoiceMapper {
  static InvoiceModel fromOrder(
      String id, Map<String, dynamic> data) {
    return InvoiceModel(
      orderId: id,
      userId: data['userId'],
      items: (data['items'] as List)
          .map(
            (i) => InvoiceItem(
              name: i['name'],
              qty: i['qty'],
              price: (i['price'] as num).toDouble(),
            ),
          )
          .toList(),
      subtotal: (data['subtotal'] as num).toDouble(),
      vatRate: (data['vatRate'] as num).toDouble(),
      vatAmount: (data['vatAmount'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      paymentMethod: data['paymentMethod'],
      createdAt:
          (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
