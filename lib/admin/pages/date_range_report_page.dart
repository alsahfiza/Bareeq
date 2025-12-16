import 'package:flutter/material.dart';
import '../../shared/models/date_range_report_model.dart';
import '../../shared/services/date_range_report_service.dart';
import '../layout/admin_layout.dart';

class DateRangeReportPage extends StatefulWidget {
  const DateRangeReportPage({super.key});

  @override
  State<DateRangeReportPage> createState() =>
      _DateRangeReportPageState();
}

class _DateRangeReportPageState
    extends State<DateRangeReportPage> {
  final _service = DateRangeReportService();

  DateTime? startDate;
  DateTime? endDate;
  DateRangeReport? report;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Date Range Report',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE PICKERS
            Row(
              children: [
                _dateButton(
                  label: 'Start Date',
                  date: startDate,
                  onPick: (d) =>
                      setState(() => startDate = d),
                ),
                const SizedBox(width: 16),
                _dateButton(
                  label: 'End Date',
                  date: endDate,
                  onPick: (d) =>
                      setState(() => endDate = d),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  child: const Text('Generate'),
                  onPressed: _generate,
                ),
              ],
            ),

            const SizedBox(height: 30),

            if (loading) const CircularProgressIndicator(),

            if (report != null && !loading)
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Orders: ${report!.totalOrders}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Revenue: ${report!.totalRevenue.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required Function(DateTime) onPick,
  }) {
    return OutlinedButton(
      child: Text(
        date == null
            ? label
            : '${date.year}-${date.month}-${date.day}',
      ),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );

        if (picked != null) onPick(picked);
      },
    );
  }

  Future<void> _generate() async {
    if (startDate == null || endDate == null) return;

    setState(() => loading = true);

    final result = await _service.getReport(
      start: startDate!,
      end: endDate!,
    );

    setState(() {
      report = result;
      loading = false;
    });
  }
}
