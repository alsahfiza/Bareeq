import '../../domain/entities/export_profile.dart';

const exportProfiles = [
  ExportProfile(
    type: ExportProfileType.products,
    label: 'Products',
    columns: [
      'id',
      'name',
      'sku',
      'price',
      'cost',
      'isActive',
    ],
  ),
  ExportProfile(
    type: ExportProfileType.inventory,
    label: 'Inventory',
    columns: [
      'productId',
      'storeId',
      'quantity',
    ],
  ),
  ExportProfile(
    type: ExportProfileType.sales,
    label: 'Sales',
    columns: [
      'id',
      'productId',
      'quantity',
      'total',
      'profit',
      'createdAt',
    ],
  ),
  ExportProfile(
    type: ExportProfileType.audit,
    label: 'Audit Logs',
    columns: [
      'timestamp',
      'entity',
      'entityId',
      'action',
      'performedBy',
    ],
  ),
];
