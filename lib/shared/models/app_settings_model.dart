class AppSettings {
  final double deliveryFee;
  final double freeDeliveryThreshold;
  final String vatRegistrationNumber;

  AppSettings({
    required this.deliveryFee,
    required this.freeDeliveryThreshold,
    required this.vatRegistrationNumber,
  });

  factory AppSettings.fromMap(Map<String, dynamic>? data) {
    return AppSettings(
      deliveryFee: (data?['deliveryFee'] ?? 15).toDouble(),
      freeDeliveryThreshold:
          (data?['freeDeliveryThreshold'] ?? 0).toDouble(),
      vatRegistrationNumber:
          data?['vatRegistrationNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deliveryFee': deliveryFee,
      'freeDeliveryThreshold': freeDeliveryThreshold,
      'vatRegistrationNumber': vatRegistrationNumber,
    };
  }
}
