import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  DateTime? _from;
  DateTime? _to;

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Filters
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickDate(true),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _from == null
                      ? 'From date'
                      : _from!.toIso8601String().split('T').first,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _pickDate(false),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _to == null
                      ? 'To date'
                      : _to!.toIso8601String().split('T').first,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // KPI cards
          Row(
            children: const [
              _KpiCard(title: 'Revenue', value: '12,500 SAR'),
              SizedBox(width: 16),
              _KpiCard(title: 'Profit', value: '3,200 SAR'),
              SizedBox(width: 16),
              _KpiCard(title: 'Transactions', value: '84'),
            ],
          ),

          const SizedBox(height: 24),

          // Table
          Expanded(
            child: Card(
              child: ListView(
                children: [
                  _tableHeader(),
                  const Divider(height: 1),
                  ...List.generate(
                    10,
                    (i) => _tableRow(
                      id: '#S-10$i',
                      product: 'Product $i',
                      qty: 1 + i,
                      total: '${120 + i * 5} SAR',
                      date: '2025-01-${10 + i}',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: null,
                icon: const Icon(Icons.chevron_left),
              ),
              const Text('Page 1'),
              IconButton(
                onPressed: null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: const [
          _Cell('Sale ID', flex: 2, bold: true),
          _Cell('Product', flex: 3, bold: true),
          _Cell('Qty', flex: 1, bold: true),
          _Cell('Total', flex: 2, bold: true),
          _Cell('Date', flex: 2, bold: true),
        ],
      ),
    );
  }

  Widget _tableRow({
    required String id,
    required String product,
    required int qty,
    required String total,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          _Cell(id, flex: 2),
          _Cell(product, flex: 3),
          _Cell(qty.toString(), flex: 1),
          _Cell(total, flex: 2),
          _Cell(date, flex: 2),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;

  const _KpiCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  final bool bold;

  const _Cell(
    this.text, {
    required this.flex,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}