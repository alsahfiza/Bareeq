import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../shared/services/cart_service.dart';
import '../../shared/services/checkout_service.dart';
import '../../shared/services/payment/payment_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String paymentMethod = 'cod';

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final checkoutService = CheckoutService();
    final paymentService = getPaymentService();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: StreamBuilder(
        stream: cartService.getCart(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Cart empty'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: items
                        .map((i) => ListTile(
                              title: Text(i.name),
                              trailing: Text('${i.qty} × ${i.price}'),
                            ))
                        .toList(),
                  ),
                ),

                if (!kIsWeb)
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
                    child: const Text('Place Order'),
                    onPressed: () async {
                      final orderId =
                          await checkoutService.createOrder(
                        items: items,
                        deliveryFee: 0,
                        paymentMethod: paymentMethod,
                      );

                      if (paymentMethod == 'stripe' && !kIsWeb) {
                        await paymentService.pay(
                          amount: 0,
                          orderId: orderId,
                        );
                      }

                      await checkoutService.clearCart();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
