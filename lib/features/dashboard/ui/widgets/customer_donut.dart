import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/layout/admin_card.dart';
import '../../providers/customer_donut_provider.dart';

class CustomerDonut extends ConsumerWidget {
  const CustomerDonut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(customerDonutProvider);

    return AdminCard(
      title: 'Customers',
      child: SizedBox(
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${e.label}: ${e.value}%'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
