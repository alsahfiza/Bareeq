import 'package:flutter/material.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/models/app_settings_model.dart';
import '../../shared/services/cart_service.dart';
import '../../shared/services/checkout_service.dart';
import '../../shared/services/settings_service.dart';
import '../../shared/services/payment_service.dart';
import '../../core/constants.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String paymentMethod = 'stripe';

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
                return const Center(child: CircularProgressIndicator());
              }

              final items = cartSnap.data!;
              if (items.isEmpty) {
                return const Center(child: Text('Cart empty'));
              }

              final subtotal =
                  items.fold<double>(0, (s, i) => s + (i.price * i.qty));
              final vatAmount = subtotal * VAT_RATE;
              final deliveryFee =
                  subtotal >= settings.freeDeliveryThreshold
                      ? 0
                      : settings.deliveryFee;
              final total = subtotal + vatAmount + deliveryFee;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: items
                            .map((i) => ListTile(
                                  title: Text(i.name),
                                  trailing:
                                      Text('${i.qty} × ${i.price}'),
                                ))
                            .toList(),
                      ),
                    ),

                    const Divider(),

                    _row('Subtotal', subtotal),
                    _row('VAT (15%)', vatAmount),
                    _row('Delivery', deliveryFee),
                    const Divider(),
                    _row('TOTAL', total, bold: true),

                    const SizedBox(height: 16),

                    RadioListTile(
                      title: const Text('Pay by Card'),
                      value: 'stripe',
                      groupValue: paymentMethod,
                      onChanged: (v) =>
                          setState(() => paymentMethod = v!),
                    ),
                    RadioListTile(
                      title: const Text('Cash on Delivery'),
                      value: 'cod',
                      groupValue: paymentMethod,
                      onChanged: (v) =>
                          setState(() => paymentMethod = v!),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(paymentMethod == 'cod'
                            ? 'Place Order'
                            : 'Pay Now'),
                        onPressed: () async {
                          final orderId =
                              await checkoutService.createOrder(
                            items: items,
                            deliveryFee: deliveryFee,
                            paymentMethod: paymentMethod,
                          );

                          if (paymentMethod == 'stripe') {
                            await paymentService.pay(
                              amount: total,
                              orderId: orderId,
                            );
                          }

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

  Widget _row(String label, double value,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        Text(value.toStringAsFixed(2),
            style:
                bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
      ],
    );
  }
}
