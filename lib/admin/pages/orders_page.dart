import 'package:flutter/material.dart';
import '../../shared/services/order_service.dart';
import '../../shared/models/order_model.dart';
import '../layout/admin_layout.dart';
import 'order_details_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = OrderService();

    return AdminLayout(
      title: 'Orders',
      body: StreamBuilder<List<OrderModel>>(
        stream: service.getOrders(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          return DataTable(
            columns: const [
              DataColumn(label: Text('Order')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: orders.map((o) {
              return DataRow(cells: [
                DataCell(Text(o.id)),
                DataCell(Text(o.total.toString())),
                DataCell(Text(o.status)),
                DataCell(
                  TextButton(
                    child: const Text('View'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsPage(order: o),
                        ),
                      );
                    },
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}
