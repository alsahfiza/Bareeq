enum ExportProfileType {
  products,
  inventory,
  sales,
  audit,
}

class ExportProfile {
  final ExportProfileType type;
  final String label;
  final List<String> columns;

  const ExportProfile({
    required this.type,
    required this.label,
    required this.columns,
  });
}
