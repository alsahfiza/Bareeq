class AppSettings {
  final double deliveryFee;
  final double freeDeliveryThreshold;

  AppSettings({
    required this.deliveryFee,
    required this.freeDeliveryThreshold,
  });

  factory AppSettings.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return AppSettings(
        deliveryFee: 15,
        freeDeliveryThreshold: 0,
      );
    }

    return AppSettings(
      deliveryFee: (data['deliveryFee'] ?? 15).toDouble(),
      freeDeliveryThreshold:
          (data['freeDeliveryThreshold'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deliveryFee': deliveryFee,
      'freeDeliveryThreshold': freeDeliveryThreshold,
    };
  }
}
