import 'package:flutter/foundation.dart';

class CustomerSearchDialog extends StatefulWidget {
  const CustomerSearchDialog({super.key});

  @override
  State<CustomerSearchDialog> createState() => _CustomerSearchDialogState();
}

class _CustomerSearchDialogState extends State<CustomerSearchDialog> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Find Customer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '05XXXXXXXX',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          Consumer<CustomerProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: () {
                  final customer = provider.findByPhone(_phoneController.text);
                  Navigator.pop(context, customer);
                },
                child: const Text('Search'),
              );
            },
          ),
        ],
      ),
    );
  }
}