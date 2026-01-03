import 'package:flutter/material.dart';
import 'barcode_input_field.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_back),
                    //   onPressed: () => Navigator.pop(context),
                    //   ),
                    //   const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Save Product"),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // ================= MAIN CONTENT =================
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 3, child: _LeftColumn()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: _RightColumn()),
                    ],
                  )
                : Column(
                    children: const [
                      _LeftColumn(),
                      SizedBox(height: 16),
                      _RightColumn(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// LEFT COLUMN (Product Info + Inventory + Description)
// =======================================================
class _LeftColumn extends StatelessWidget {
  const _LeftColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ProductInfoCard(),
        SizedBox(height: 16),
        _InventoryCard(),
        SizedBox(height: 16),
        _DescriptionCard(),
      ],
    );
  }
}

// =======================================================
// RIGHT COLUMN (Images + Pricing)
// =======================================================
class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ImagesCard(),
        SizedBox(height: 16),
        _PricingCard(),
      ],
    );
  }
}

// =======================================================
// PRODUCT INFO
// =======================================================
class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard();

  @override
  Widget build(BuildContext context) {
    final barcodeController = TextEditingController();
    return _Card(
      title: "Product Information",
      child: Column(
        children: [
          _TextField(label: "Product Name *"),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _TextField(label: "SKU"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BarcodeInputField(
                  controller: barcodeController,
                ),
              ),
            ],
          ),


          const SizedBox(height: 12),

          Row(
            children: const [
              Expanded(child: _Dropdown(label: "Category")),
              SizedBox(width: 12),
              Expanded(child: _TextField(label: "Brand")),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: const [
              Expanded(child: _Dropdown(label: "Unit")),
              SizedBox(width: 12),
              Expanded(child: _StatusToggle()),
            ],
          ),
        ],
      ),
    );
  }
}

// =======================================================
// BARCODE FIELD WITH SCAN BUTTON (VISIBLE)
// =======================================================
class _BarcodeField extends StatelessWidget {
  const _BarcodeField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Barcode",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: "Scan barcode",
          onPressed: () {}, // UI only
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}

// =======================================================
// INVENTORY
// =======================================================
class _InventoryCard extends StatelessWidget {
  const _InventoryCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Inventory",
      child: Row(
        children: const [
          Expanded(
            child: _TextField(
              label: "Quantity",
              isNumber: true,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _TextField(
              label: "Low Stock Alert",
              isNumber: true,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// DESCRIPTION (COLLAPSIBLE STYLE LOOK)
// =======================================================
class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Description & Notes",
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Optional description or internal notes",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// IMAGES
// =======================================================
class _ImagesCard extends StatelessWidget {
  const _ImagesCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Product Images",
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 32),
              SizedBox(height: 8),
              Text("Drag & drop images here"),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// PRICING
// =======================================================
class _PricingCard extends StatelessWidget {
  const _PricingCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Pricing",
      child: Column(
        children: const [
          _TextField(label: "Cost Price", isNumber: true),
          SizedBox(height: 12),
          _TextField(label: "Selling Price", isNumber: true),
          SizedBox(height: 12),
          _Dropdown(label: "VAT"),
        ],
      ),
    );
  }
}

// =======================================================
// SHARED COMPONENTS
// =======================================================
class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String label;
  final bool isNumber;

  const _TextField({required this.label, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  const _Dropdown({required this.label});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: const [],
      onChanged: (_) {},
    );
  }
}

class _StatusToggle extends StatelessWidget {
  const _StatusToggle();

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "Status",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Active"),
          Switch(value: true, onChanged: null),
        ],
      ),
    );
  }
}
