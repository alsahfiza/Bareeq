import 'package:flutter/material.dart';
import '../../shared/models/order_model.dart';
import '../../shared/services/order_service.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final service = OrderService();

    return Scaffold(
      appBar: AppBar(title: Text('Order ${order.id}')),
      body: Column(
        children: [
          ...order.items.map((i) => ListTile(
                title: Text(i.name),
                trailing: Text('${i.qty} × ${i.price}'),
              )),
          const Divider(),
          Text('Total: ${order.total}'),
          const SizedBox(height: 20),
          if (order.status == 'pending')
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Accept'),
                  onPressed: () async {
                    await service.acceptOrder(order);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  child: const Text('Decline'),
                  onPressed: () async {
                    await service.declineOrder(order.id, 'Out of stock');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
