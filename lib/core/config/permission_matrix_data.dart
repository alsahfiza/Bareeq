import '../../domain/entities/permission_matrix.dart';

const permissionMatrixData = [
  PermissionMatrix(
    feature: 'View Dashboard KPIs',
    viewer: true,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'View Products',
    viewer: true,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Create / Edit Products',
    viewer: false,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Adjust Inventory',
    viewer: false,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'View Inventory History',
    viewer: true,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Manage Inventory Rules',
    viewer: false,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'View Sales',
    viewer: true,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Export Sales Data',
    viewer: false,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'View Audit Logs',
    viewer: true,
    admin: true,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Export Audit Logs',
    viewer: false,
    admin: false,
    superAdmin: true,
  ),
  PermissionMatrix(
    feature: 'Manage Users',
    viewer: false,
    admin: false,
    superAdmin: true,
  ),
];
