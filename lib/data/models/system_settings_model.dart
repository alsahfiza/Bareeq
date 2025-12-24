import '../../domain/entities/system_settings_entity.dart';

class SystemSettingsModel {
  final String currencyCode;
  final String dateFormat;
  final int defaultMinimumStock;

  SystemSettingsModel({
    required this.currencyCode,
    required this.dateFormat,
    required this.defaultMinimumStock,
  });

  factory SystemSettingsModel.fromMap(Map<String, dynamic> data) {
    return SystemSettingsModel(
      currencyCode: data['currencyCode'],
      dateFormat: data['dateFormat'],
      defaultMinimumStock: data['defaultMinimumStock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currencyCode': currencyCode,
      'dateFormat': dateFormat,
      'defaultMinimumStock': defaultMinimumStock,
    };
  }

  SystemSettingsEntity toEntity() {
    return SystemSettingsEntity(
      currencyCode: currencyCode,
      dateFormat: dateFormat,
      defaultMinimumStock: defaultMinimumStock,
    );
  }

  static SystemSettingsModel fromEntity(
    SystemSettingsEntity e,
  ) {
    return SystemSettingsModel(
      currencyCode: e.currencyCode,
      dateFormat: e.dateFormat,
      defaultMinimumStock: e.defaultMinimumStock,
    );
  }
}
