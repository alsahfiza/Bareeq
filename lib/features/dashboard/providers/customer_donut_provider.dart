import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/customer_segment.dart';

final customerDonutProvider =
    Provider<List<CustomerSegment>>((ref) {
  return const [
    CustomerSegment(label: 'Retail', value: 45),
    CustomerSegment(label: 'Wholesale', value: 30),
    CustomerSegment(label: 'Online', value: 25),
  ];
});
