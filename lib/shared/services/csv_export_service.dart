import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class CsvExportService {
  final _db = FirebaseFirestore.instance;

  Future<File> exportProducts() async {
    final snapshot = await _db.collection('products').get();

    final rows = <List<dynamic>>[
      ['ID', 'Name', 'Price', 'Stock', 'Category', 'On Sale'],
    ];

    for (final doc in snapshot.docs) {
      final d = doc.data();
      rows.add([
        doc.id,
        d['name'],
        d['price'],
        d['stock'],
        d['categoryId'],
        d['onSale'],
      ]);
    }

    return _saveCsv('products.csv', rows);
  }

  Future<File> exportOrders() async {
    final snapshot = await _db.collection('orders').get();

    final rows = <List<dynamic>>[
      [
        'Order ID',
        'User ID',
        'Total',
        'Payment Method',
        'Status',
        'Created At'
      ],
    ];

    for (final doc in snapshot.docs) {
      final d = doc.data();
      rows.add([
        doc.id,
        d['userId'],
        d['total'],
        d['paymentMethod'],
        d['status'],
        d['createdAt'],
      ]);
    }

    return _saveCsv('orders.csv', rows);
  }

  Future<File> _saveCsv(String fileName, List<List<dynamic>> rows) async {
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    return file.writeAsString(csv);
  }
}
