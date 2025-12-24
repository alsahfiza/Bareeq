import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/exports/services/export_service.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(ref);
});
