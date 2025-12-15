import 'package:flutter/material.dart';
import '../../shared/models/order_model.dart';
import '../../shared/services/customer_orders_service.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'declined':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = CustomerOrdersService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<OrderModel>>(
        stream: service.getMyOrders(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final o = orders[i];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text('Order #${o.id.substring(0, 6)}'),
                  subtitle: Text(
                    o.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(o.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    ...o.items.map((item) => ListTile(
                          title: Text(item.name),
                          trailing:
                              Text('${item.qty} × ${item.price}'),
                        )),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            o.total.toStringAsFixed(2),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
