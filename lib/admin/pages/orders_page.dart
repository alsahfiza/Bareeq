import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/services/invoice/invoice_service.dart';
import '../layout/admin_layout.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceService = getInvoiceService();

    return AdminLayout(
      title: 'Orders',
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data =
                  doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Order ${doc.id.substring(0, 6)}'),
                subtitle: Text('Total: ${data['total']}'),
                trailing: kIsWeb
                    ? const Text('Invoice on mobile')
                    : IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        onPressed: () async {
                          await invoiceService.generate(
                            orderId: doc.id,
                            arabic: false,
                          );
                        },
                      ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
