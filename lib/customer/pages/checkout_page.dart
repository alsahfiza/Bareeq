import 'package:flutter/material.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/models/app_settings_model.dart';
import '../../shared/services/cart_service.dart';
import '../../shared/services/checkout_service.dart';
import '../../shared/services/settings_service.dart';
import '../../shared/services/payment_service.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final checkoutService = CheckoutService();
    final settingsService = SettingsService();
    final paymentService = PaymentService();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: StreamBuilder<AppSettings>(
        stream: settingsService.getSettings(),
        builder: (_, settingsSnap) {
          if (!settingsSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsSnap.data!;

          return StreamBuilder<List<CartItem>>(
            stream: cartService.getCart(),
            builder: (_, cartSnap) {
              if (!cartSnap.hasData) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              final items = cartSnap.data!;
              if (items.isEmpty) {
                return const Center(child: Text('Cart empty'));
              }

              final subtotal = items.fold<double>(
                0,
                (s, i) => s + (i.price * i.qty),
              );

              final deliveryFee =
                  subtotal >= settings.freeDeliveryThreshold
                      ? 0
                      : settings.deliveryFee;

              final total = subtotal + deliveryFee;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: items
                            .map((i) => ListTile(
                                  title: Text(i.name),
                                  trailing: Text(
                                      '${i.qty} × ${i.price}'),
                                ))
                            .toList(),
                      ),
                    ),
                    Text('Total: $total'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Pay Now'),
                        onPressed: () async {
                          final orderId =
                              await checkoutService.createOrder(
                            items: items,
                            deliveryFee: deliveryFee,
                          );

                          await paymentService.pay(
                            amount: total,
                            orderId: orderId,
                          );

                          await checkoutService.clearCart();

                          Navigator.popUntil(
                              context, (r) => r.isFirst);
                        },
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
