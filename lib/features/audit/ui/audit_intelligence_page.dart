import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intelligence/audit_intelligence_provider.dart';

class AuditIntelligencePage extends ConsumerWidget {
  const AuditIntelligencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(auditIntelligenceProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Audit Intelligence',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _section(
                'Most Active Users',
                state.byUser
                    .take(10)
                    .map(
                      (u) =>
                          '${u.userId}: ${u.actions} actions',
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              _section(
                'Most Changed Entities',
                state.byEntity
                    .take(10)
                    .map(
                      (e) =>
                          '${e.entity}: ${e.actions} actions',
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              _section(
                'Activity by Day',
                state.byDay
                    .map(
                      (d) =>
                          '${d.day}: ${d.actions} actions',
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _section(
    String title,
    List<String> rows,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(r),
          ),
      ],
    );
  }
}
