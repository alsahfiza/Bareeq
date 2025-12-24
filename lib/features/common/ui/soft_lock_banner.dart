import 'package:flutter/material.dart';
import '../../domain/entities/soft_lock_entity.dart';

class SoftLockBanner extends StatelessWidget {
  final SoftLockEntity lock;

  const SoftLockBanner({
    super.key,
    required this.lock,
  });

  @override
  Widget build(BuildContext context) {
    if (lock.isExpired) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          const Icon(Icons.lock, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This item is currently being edited by '
              '${lock.lockedBy}. Changes may conflict.',
            ),
          ),
        ],
      ),
    );
  }
}
