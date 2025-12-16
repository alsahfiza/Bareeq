import 'dart:convert';

class ZatcaQrService {
  static String generate({
    required String sellerName,
    required String vatNumber,
    required DateTime timestamp,
    required double total,
    required double vat,
  }) {
    final bytes = <int>[
      ..._tlv(1, sellerName),
      ..._tlv(2, vatNumber),
      ..._tlv(3, timestamp.toIso8601String()),
      ..._tlv(4, total.toStringAsFixed(2)),
      ..._tlv(5, vat.toStringAsFixed(2)),
    ];

    return base64Encode(bytes);
  }

  static List<int> _tlv(int tag, String value) {
    final v = utf8.encode(value);
    return [tag, v.length, ...v];
  }
}
