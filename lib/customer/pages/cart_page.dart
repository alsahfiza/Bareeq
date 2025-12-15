import 'package:flutter/material.dart';
import '../../shared/services/cart_service.dart';
import '../../shared/models/cart_item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CartService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: StreamBuilder<List<CartItem>>(
        stream: service.getCart(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final total = items.fold<double>(
              0, (sum, i) => sum + (i.price * i.qty));

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: items.map((i) {
                    return ListTile(
                      title: Text(i.name),
                      subtitle: Text('${i.qty} × ${i.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            service.removeFromCart(i.productId),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Total: $total',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
          ElevatedButton(
            child: const Text('Checkout'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutPage()),
              );
            },
          ),

        },
      ),
    );
  }
}
