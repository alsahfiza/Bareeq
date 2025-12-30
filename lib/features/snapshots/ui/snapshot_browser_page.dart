import 'package:flutter/material.dart';

class SnapshotBrowserPage extends StatefulWidget {
  const SnapshotBrowserPage({super.key});

  @override
  State<SnapshotBrowserPage> createState() => _SnapshotBrowserPageState();
}

class _SnapshotBrowserPageState extends State<SnapshotBrowserPage> {
  String _selectedType = 'All';

  final List<Map<String, dynamic>> _snapshots = [
    {
      'type': 'Products',
      'count': 120,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'type': 'Inventory',
      'count': 340,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'type': 'Sales',
      'count': 87,
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'type': 'Users',
      'count': 12,
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedType == 'All'
        ? _snapshots
        : _snapshots.where((s) => s['type'] == _selectedType).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),
          _filters(),
          const SizedBox(height: 16),
          Expanded(child: _table(filtered)),
        ],
      ),
    );
  }

  Widget _header() {
    return const Text(
      'Snapshots',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _filters() {
    return Row(
      children: [
        const Text('Type:'),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _selectedType,
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All')),
            DropdownMenuItem(value: 'Products', child: Text('Products')),
            DropdownMenuItem(value: 'Inventory', child: Text('Inventory')),
            DropdownMenuItem(value: 'Sales', child: Text('Sales')),
            DropdownMenuItem(value: 'Users', child: Text('Users')),
          ],
          onChanged: (v) {
            if (v != null) {
              setState(() => _selectedType = v);
            }
          },
        ),
      ],
    );
  }

  Widget _table(List<Map<String, dynamic>> data) {
    return Card(
      elevation: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Records')),
            DataColumn(label: Text('Created At')),
            DataColumn(label: Text('Actions')),
          ],
          rows: data.map((s) {
            return DataRow(cells: [
              DataCell(Text(s['type'])),
              DataCell(Text(s['count'].toString())),
              DataCell(Text(_fmt(s['createdAt']))),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        _showViewDialog(s);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(s);
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showViewDialog(Map<String, dynamic> snapshot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Snapshot Details'),
        content: Text(
          'Type: ${snapshot['type']}\n'
          'Records: ${snapshot['count']}\n'
          'Created: ${_fmt(snapshot['createdAt'])}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> snapshot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Snapshot'),
        content: const Text(
          'This action cannot be undone.\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
