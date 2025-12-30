import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sales_notifier.dart';
import 'sales_state.dart';

final salesProvider =
    StateNotifierProvider<SalesNotifier, SalesState>(
  (ref) => SalesNotifier(),
);
