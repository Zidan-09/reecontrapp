import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

/// Card of a single object in the listing (CARD-019, CARD-020).
///
/// Shows name, location, situation and description from the remote
/// record. The full description is always displayed with wrapping
/// and without truncation, so a 200-character text fits without
/// overflow and remains fully readable (CARD-019 technical note).
///
/// The situation (CARD-020) is identified with a Material 3 [Chip]
/// combining text in Portuguese, an icon and a color from the app
/// theme, so the distinction does not rely on color alone. Lost
/// items use [ColorScheme.errorContainer] with a search icon and
/// found items use [ColorScheme.tertiaryContainer] with a check
/// icon, applied the same way to every item.
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

  IconData _statusIcon(ItemStatus status) {
    switch (status) {
      case ItemStatus.lost:
        return Icons.search;
      case ItemStatus.found:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLost = item.status == ItemStatus.lost;
    final chipColor = isLost
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    final chipOnColor = isLost
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Chip(
              avatar: Icon(_statusIcon(item.status), color: chipOnColor),
              label: Text(_statusLabel(item.status)),
              backgroundColor: chipColor,
              labelStyle: TextStyle(color: chipOnColor),
              side: BorderSide.none,
            ),
            const SizedBox(height: 8),
            Text('Local: ${item.location}'),
            const SizedBox(height: 8),
            Text(item.description, softWrap: true),
          ],
        ),
      ),
    );
  }
}
