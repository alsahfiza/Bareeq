import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sales History'),
            actions: [
              Chip(
                label: Text('Today: ${salesProvider.todaySalesCount} sales'),
                backgroundColor: Colors.teal.shade100,
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('SAR ${salesProvider.todayRevenue.toStringAsFixed(2)}'),
                backgroundColor: Colors.yellow.shade100,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: CustomDataTable(
            headers: const [
              'Sale #',
              'Date & Time',
              'Items',
              'Total',
              'Payment',
              'Cashier',
              'Actions',
            ],
            rows: salesProvider.sales.map((sale) {
              return [
                Text(sale.saleNumber,
                    style: const TextStyle(fontFamily: 'monospace')),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(sale.saleDate)),
                Text('${sale.items.length} items'),
                Text(
                  'SAR ${sale.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(sale.paymentMethod.displayName),
                  backgroundColor: Colors.teal.shade100,
                ),
                Text(sale.cashierName),
                IconButton(
                  icon: const Icon(Icons.receipt),
                  onPressed: () {
                    _showSaleDetails(context, sale);
                  },
                ),
              ];
            }).toList(),
            isLoading: salesProvider.isLoading,
            hasMore: salesProvider.hasMore,
            onLoadMore: () => salesProvider.loadSales(),
            emptyMessage: 'No sales yet',
          ),
        );
      },
    );
  }

  void _showSaleDetails(BuildContext context, SaleModel sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sale ${sale.saleNumber}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(sale.saleDate)}'),
              Text('Cashier: ${sale.cashierName}'),
              Text('Payment: ${sale.paymentMethod.displayName}'),
              const Divider(),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...sale.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(item.productName)),
                        Text('${item.quantity} x SAR ${item.unitPrice}'),
                        Text('SAR ${item.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:'),
                  Text('SAR ${sale.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax:'),
                  Text('SAR ${sale.tax.toStringAsFixed(2)}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('SAR ${sale.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement print receipt
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }
}