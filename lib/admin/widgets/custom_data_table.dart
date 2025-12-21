import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final String? emptyMessage;

  const CustomDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.isLoading = false,
    this.onLoadMore,
    this.hasMore = false,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Table(
            columnWidths: _getColumnWidths(),
            children: [
              TableRow(
                children: headers.map((header) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      header,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Table Body
        if (rows.isEmpty && !isLoading)
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage ?? 'No data available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Table(
              columnWidths: _getColumnWidths(),
              children: rows.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final isLastRow = index == rows.length - 1;

                return TableRow(
                  decoration: BoxDecoration(
                    border: isLastRow
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                  ),
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: cell,
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),

        // Loading indicator
        if (isLoading)
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          ),

        // Load more button
        if (!isLoading && hasMore && onLoadMore != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.refresh),
              label: const Text('Load More'),
            ),
          ),
      ],
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    // Distribute columns evenly
    return Map.fromIterable(
      List.generate(headers.length, (index) => index),
      key: (i) => i as int,
      value: (i) => const FlexColumnWidth(),
    );
  }
}

// Action Button for tables
class TableActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final String? tooltip;

  const TableActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}