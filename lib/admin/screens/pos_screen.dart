import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final _searchController = TextEditingController();
  PaymentMethod _selectedPayment = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SalesProvider, ProductProvider>(
      builder: (context, salesProvider, productProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('نقطة البيع / Point of Sale'),
          ),
          body: Row(
            children: [
              // Left: Product Selection
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search products or scan barcode...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          productProvider.searchProducts(query);
                        },
                      ),
                    ),
                    
                    // Products Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: productProvider.products.length,
                        itemBuilder: (context, index) {
                          final product = productProvider.products[index];
                          return GestureDetector(
                            onTap: () {
                              salesProvider.addItemToCurrentSale(product);
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product image or placeholder
                                  Container(
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Text(
                                        product.imageUrls.isNotEmpty ? '📦' : '📦',
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'SAR ${product.effectivePrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Stock: ${product.stock}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: product.stock > 0 
                                                ? Colors.green 
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Cart & Checkout
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Cart Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Current Sale',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Cart Items
                    Expanded(
                      child: ListView.builder(
                        itemCount: salesProvider.currentSaleItems.length,
                        itemBuilder: (context, index) {
                          final item = salesProvider.currentSaleItems[index];
                          return ListTile(
                            title: Text(item.productName),
                            subtitle: Text('SAR ${item.unitPrice} x ${item.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'SAR ${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    salesProvider.removeItemFromCurrentSale(item.productId);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Totals
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          _buildTotalRow('Subtotal', salesProvider.currentSubtotal),
                          _buildTotalRow('Discount', salesProvider.currentDiscount),
                          _buildTotalRow('Tax (15%)', salesProvider.currentTax),
                          const Divider(),
                          _buildTotalRow(
                            'TOTAL',
                            salesProvider.currentTotal,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    
                    // Payment Method
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<PaymentMethod>(
                        value: _selectedPayment,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method',
                        ),
                        items: PaymentMethod.values.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPayment = value!;
                          });
                        },
                      ),
                    ),
                    
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: salesProvider.currentSaleItems.isEmpty
                                  ? null
                                  : () async {
                                      final authProvider = context.read<AuthProvider>();
                                      final success = await salesProvider.completeSale(
                                        paymentMethod: _selectedPayment,
                                        cashierName: authProvider.currentUserData?.name ?? 'Unknown',
                                        cashierId: authProvider.currentUser?.uid ?? '',
                                      );
                                      
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Sale completed!')),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Text('Complete Sale'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                salesProvider.clearCurrentSale();
                              },
                              child: const Text('Clear Cart'),
                            ),
                          ),
                        ],
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
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'SAR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}