import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// Import providers and models

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return Scaffold(
          body: Column(
            children: [
              // Filter Bar
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Status Filter
                    DropdownButton<OrderStatus?>(
                      value: _selectedStatus,
                      hint: const Text('All Orders'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Orders'),
                        ),
                        ...OrderStatus.values.map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(_formatStatus(status)),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                        orderProvider.filterByStatus(value);
                      },
                    ),
                    const Spacer(),
                    // Stats
                    _buildStatChip(
                      context,
                      'Total',
                      orderProvider.totalOrders.toString(),
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      context,
                      'Pending',
                      orderProvider.pendingOrders.toString(),
                      Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      context,
                      'Delivered',
                      orderProvider.deliveredOrders.toString(),
                      Colors.green,
                    ),
                  ],
                ),
              ),

              // Orders Table
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomDataTable(
                    headers: const [
                      'Order ID',
                      'Customer',
                      'Date',
                      'Items',
                      'Total',
                      'Status',
                      'Payment',
                      'Actions',
                    ],
                    rows: orderProvider.orders.map((order) {
                      return [
                        // Order ID
                        Text(
                          '#${order.id.substring(0, 8)}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Customer
                        FutureBuilder<UserModel?>(
                          future: context
                              .read<UserProvider>()
                              .getUserById(order.userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data?.name ?? 'N/A');
                            }
                            return const Text('Loading...');
                          },
                        ),
                        // Date
                        Text(
                          DateFormat('MMM dd, yyyy').format(order.createdAt),
                        ),
                        // Items
                        Text('${order.items.length} items'),
                        // Total
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Status
                        _buildStatusChip(order.status),
                        // Payment Status
                        _buildPaymentChip(order.paymentStatus),
                        // Actions
                        Row(
                          children: [
                            TableActionButton(
                              icon: Icons.visibility,
                              tooltip: 'View Details',
                              onPressed: () =>
                                  _showOrderDetailsDialog(context, order),
                            ),
                            const SizedBox(width: 8),
                            TableActionButton(
                              icon: Icons.edit,
                              tooltip: 'Update Status',
                              onPressed: () =>
                                  _showUpdateStatusDialog(context, order),
                            ),
                          ],
                        ),
                      ];
                    }).toList(),
                    isLoading: orderProvider.isLoading,
                    hasMore: orderProvider.hasMore,
                    onLoadMore: () => orderProvider.loadOrders(),
                    emptyMessage: 'No orders found',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatChip(
      BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        break;
      case OrderStatus.processing:
        color = Colors.purple;
        break;
      case OrderStatus.shipped:
        color = Colors.indigo;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
      case OrderStatus.refunded:
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(_formatStatus(status)),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPaymentChip(PaymentStatus status) {
    Color color;
    switch (status) {
      case PaymentStatus.pending:
        color = Colors.orange;
        break;
      case PaymentStatus.paid:
        color = Colors.green;
        break;
      case PaymentStatus.failed:
        color = Colors.red;
        break;
      case PaymentStatus.refunded:
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(_formatPaymentStatus(status)),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }

  String _formatStatus(OrderStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  String _formatPaymentStatus(PaymentStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  void _showOrderDetailsDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => UpdateOrderStatusDialog(order: order),
    );
  }
}

// Order Details Dialog
class OrderDetailsDialog extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 32),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    _buildInfoRow('Order ID', '#${order.id.substring(0, 12)}'),
                    _buildInfoRow('Date',
                        DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt)),
                    const SizedBox(height: 24),

                    // Items
                    Text(
                      'Order Items',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => _buildItemRow(context, item)),

                    const Divider(height: 32),

                    // Pricing
                    _buildPriceRow(
                        context, 'Subtotal', order.subtotal, isBold: false),
                    _buildPriceRow(context, 'Tax', order.tax, isBold: false),
                    _buildPriceRow(context, 'Shipping', order.shippingCost,
                        isBold: false),
                    const Divider(height: 16),
                    _buildPriceRow(context, 'Total', order.total, isBold: true),

                    const SizedBox(height: 24),

                    // Delivery Address
                    Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(order.deliveryAddress.recipientName),
                    Text(order.deliveryAddress.phoneNumber),
                    Text(order.deliveryAddress.fullAddress),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (item.productImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.productImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Qty: ${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, double amount,
      {required bool isBold}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Update Order Status Dialog
class UpdateOrderStatusDialog extends StatefulWidget {
  final OrderModel order;

  const UpdateOrderStatusDialog({super.key, required this.order});

  @override
  State<UpdateOrderStatusDialog> createState() =>
      _UpdateOrderStatusDialogState();
}

class _UpdateOrderStatusDialogState extends State<UpdateOrderStatusDialog> {
  late OrderStatus _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Order Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<OrderStatus>(
            value: _selectedStatus,
            items: OrderStatus.values
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.name[0].toUpperCase() + status.name.substring(1),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _updateStatus,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isLoading = true;
    });

    final success = await context
        .read<OrderProvider>()
        .updateOrderStatus(widget.order.id, _selectedStatus);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Order status updated successfully'
                : 'Failed to update order status',
          ),
        ),
      );
    }
  }
}