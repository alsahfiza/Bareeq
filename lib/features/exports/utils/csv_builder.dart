class CsvBuilder {
  static String build(
    List<String> columns,
    List<Map<String, dynamic>> rows,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(columns.join(','));

    for (final row in rows) {
      buffer.writeln(
        columns.map((c) => row[c]).join(','),
      );
    }
    return buffer.toString();
  }
}
