import 'package:flutter/material.dart';
import '../../shared/models/banner_model.dart';
import '../../shared/services/banner_service.dart';
import '../layout/admin_layout.dart';
import '../widgets/banner_form_dialog.dart';

class BannersPage extends StatelessWidget {
  const BannersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BannerService();

    return AdminLayout(
      title: 'Banners',
      body: StreamBuilder<List<BannerModel>>(
        stream: service.getAllBanners(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final banners = snapshot.data!;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text('Add Banner'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const BannerFormDialog(),
                    );
                  },
                ),
              ),
              Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: banners.map((b) {
                    return DataRow(cells: [
                      DataCell(Image.network(b.imageUrl, width: 80)),
                      DataCell(Text(b.type)),
                      DataCell(Icon(
                        b.isActive ? Icons.check : Icons.close,
                        color: b.isActive ? Colors.green : Colors.red,
                      )),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => service.deleteBanner(b.id),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
