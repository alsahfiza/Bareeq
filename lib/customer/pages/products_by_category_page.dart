import 'package:flutter/material.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/services/product_service.dart';
import '../../shared/services/cart_service.dart';
import '../../shared/services/wishlist_service.dart';

class ProductsByCategoryPage extends StatelessWidget {
  final String categoryId;

  const ProductsByCategoryPage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final cartService = CartService();
    final wishlistService = WishlistService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: productService.getProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return StreamBuilder<List<String>>(
            stream: wishlistService.getWishlistIds(),
            builder: (context, wishSnapshot) {
              final wishlistIds = wishSnapshot.data ?? [];

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  final bool inWishlist =
                      wishlistIds.contains(product.id);

                  final bool outOfStock = product.stock <= 0;

                  final double finalPrice = product.onSale
                      ? product.price -
                          (product.price * product.discount / 100)
                      : product.price;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// PRODUCT NAME
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// PRICE
                          Row(
                            children: [
                              if (product.onSale) ...[
                                Text(
                                  product.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                    decoration:
                                        TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  finalPrice.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else
                                Text(
                                  product.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// STOCK STATUS
                          Text(
                            outOfStock
                                ? 'Out of stock'
                                : 'In stock: ${product.stock}',
                            style: TextStyle(
                              color: outOfStock
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// ACTIONS
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              /// WISHLIST
                              IconButton(
                                icon: Icon(
                                  inWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: inWishlist
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  wishlistService
                                      .toggleWishlist(product.id);
                                },
                              ),

                              /// ADD TO CART
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('Add to Cart'),
                                onPressed: outOfStock
                                    ? null
                                    : () {
                                        cartService.addToCart(
                                          CartItem(
                                            productId: product.id,
                                            name: product.name,
                                            price: finalPrice,
                                            qty: 1,
                                          ),
                                          product.stock,
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Added to cart'),
                                            duration:
                                                Duration(seconds: 1),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
