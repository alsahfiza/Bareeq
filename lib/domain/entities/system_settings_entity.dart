class SystemSettingsEntity {
  final String currencyCode;
  final String dateFormat;
  final int defaultMinimumStock;

  const SystemSettingsEntity({
    required this.currencyCode,
    required this.dateFormat,
    required this.defaultMinimumStock,
  });

  SystemSettingsEntity copyWith({
    String? currencyCode,
    String? dateFormat,
    int? defaultMinimumStock,
  }) {
    return SystemSettingsEntity(
      currencyCode: currencyCode ?? this.currencyCode,
      dateFormat: dateFormat ?? this.dateFormat,
      defaultMinimumStock:
          defaultMinimumStock ?? this.defaultMinimumStock,
    );
  }
}
