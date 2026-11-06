import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

/// Card of a single object in the listing (CARD-019).
///
/// Shows name, location, situation and description from the remote
/// record. The full description is always displayed with wrapping
/// and without truncation, so a 200-character text fits without
/// overflow and remains fully readable (CARD-019 technical note).
/// The visual distinction between lost and found belongs to CARD-020:
/// the situation is shown here only as text in Portuguese.
class LostFoundItemCard extends StatelessWidget {
  const LostFoundItemCard({super.key, required this.item});

  final LostFoundItem item;

  String _statusLabel(ItemStatus status) {
    switch (status) {
      case ItemStatus.lost:
        return 'Perdido';
      case ItemStatus.found:
        return 'Encontrado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Situação: ${_statusLabel(item.status)}'),
            const SizedBox(height: 4),
            Text('Local: ${item.location}'),
            const SizedBox(height: 8),
            Text(item.description, softWrap: true),
          ],
        ),
      ),
    );
  }
}
