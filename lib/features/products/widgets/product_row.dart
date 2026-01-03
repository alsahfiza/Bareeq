import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';
import '../ui/view_product_page.dart';
import '../ui/edit_product_page.dart';
import '../ui/delete_confirmation_dialog.dart';
import 'status_pill.dart';
import 'action_icon.dart';

class ProductRow extends StatelessWidget {
  final ProductModel product;
  final bool selected;
  final ValueChanged<bool> onSelect;

  final double checkboxW,
      productW,
      categoryW,
      priceW,
      stockW,
      statusW,
      actionsW;

  final Map<String, bool> visibleColumns;

  const ProductRow({
    super.key,
    required this.product,
    required this.selected,
    required this.onSelect,
    required this.checkboxW,
    required this.productW,
    required this.categoryW,
    required this.priceW,
    required this.stockW,
    required this.statusW,
    required this.actionsW,
    required this.visibleColumns,
  });

  @override
  Widget build(BuildContext context) {
    final stock = product.quantity;
    final status = stock == 0
        ? 'Out'
        : stock <= product.lowStock
            ? 'Low'
            : 'Active';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: checkboxW,
            child:
                Checkbox(value: selected, onChanged: (v) => onSelect(v!)),
          ),
          SizedBox(
            width: productW,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://via.placeholder.com/48',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        product.sku,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (visibleColumns['category']!)
            SizedBox(width: categoryW, child: Text(product.category)),
          if (visibleColumns['price']!)
            SizedBox(
              width: priceW,
              child: Text('\$${product.sellingPrice}'),
            ),
          if (visibleColumns['stock']!)
            SizedBox(width: stockW, child: Text('$stock')),
          if (visibleColumns['status']!)
            SizedBox(width: statusW, child: StatusPill(status: status)),
          SizedBox(
            width: actionsW,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionIcon(
                  icon: Icons.visibility,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewProductPage(product: product),
                      ),
                    );
                  },
                ),
                ActionIcon(
                  icon: Icons.edit,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProductPage(product: product),
                      ),
                    );
                  },
                ),
                ActionIcon(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) =>
                          DeleteConfirmationDialog(itemName: product.name),
                    );
                    if (ok == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product deleted')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
