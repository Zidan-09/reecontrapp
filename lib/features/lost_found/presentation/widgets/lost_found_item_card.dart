import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

/// Card of a single object in the listing.
///
/// Shows the name first, then where it was registered ([location]) and the
/// full [description] with wrapping. The situation combines a tinted pill
/// with an icon and a Portuguese label, plus a side stripe in the same
/// status color, so lost and found items stay distinguishable without
/// relying on color alone. The registration date is shown when known and
/// hidden for legacy records carrying [LostFoundItem.unknownCreatedAt].
class LostFoundItemCard extends StatelessWidget {
  const LostFoundItemCard({super.key, required this.item});

  final LostFoundItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLost = item.status == ItemStatus.lost;

    final badgeColor = isLost
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    final onBadgeColor = isLost
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;
    final stripeColor = isLost ? colorScheme.error : colorScheme.tertiary;
    final dateLabel = _formatDate(item.createdAt);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: stripeColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: _StatusBadge(
                            isLost: isLost,
                            backgroundColor: badgeColor,
                            foregroundColor: onBadgeColor,
                          ),
                        ),
                        if (dateLabel != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _DateLabel(label: dateLabel),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.name,
                      softWrap: true,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.location,
                            softWrap: true,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      softWrap: true,
                      style: textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact pill combining icon and Portuguese label for the item status.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isLost,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final bool isLost;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLost ? Icons.search : Icons.check_circle,
            size: 16,
            color: foregroundColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isLost ? 'Perdido' : 'Encontrado',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Registration date with a calendar affordance.
class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Formats [date] as dd/MM/yyyy in local time.
///
/// Returns null for [LostFoundItem.unknownCreatedAt] so legacy records and
/// pending server timestamps never show a misleading date.
String? _formatDate(DateTime date) {
  if (date.isAtSameMomentAs(LostFoundItem.unknownCreatedAt)) {
    return null;
  }
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
