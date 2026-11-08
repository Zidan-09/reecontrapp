import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

/// Deep navy sampled from the listing background (`public/background.jpg`).
///
/// Used only for the card drop shadow so the elevation reads as part of the
/// same scene: the background light comes from the top, hence a soft
/// downward shadow. Kept at ~18% opacity so depth never becomes a smudge.
const _navyShadow = Color(0x2E0B2E5F);

/// Solid green for the "ENCONTRADO" badge.
///
/// [ColorScheme.error] already covers "PERDIDO" with theme contrast, but no
/// theme color maps cleanly to a solid "found" pill, so the value is fixed
/// to keep lost/found distinguishable by label, dot and hue.
const _foundBadge = Color(0xFF2E7D32);

/// Card of a single object in the listing.
///
/// Follows `docs/design/card-design-idea.jpg` without the object photo
/// (image upload is out of scope) and without the contact/details buttons
/// (no approved route or behavior yet): status row with a solid pill,
/// bold title, two-column local/date block and a labeled description.
class LostFoundItemCard extends StatelessWidget {
  const LostFoundItemCard({super.key, required this.item});

  final LostFoundItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLost = item.status == ItemStatus.lost;

    final badgeColor = isLost ? colorScheme.error : _foundBadge;

    return Container(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        boxShadow: const [
          BoxShadow(color: _navyShadow, blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Status',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                _StatusBadge(isLost: isLost, backgroundColor: badgeColor),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              softWrap: true,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _InfoColumn(
                    icon: Icons.place_outlined,
                    label: 'Local',
                    value: item.location,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _InfoColumn(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data',
                    value: _formatDate(item.createdAt),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Descrição',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              softWrap: true,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Solid pill with a white dot and an uppercase Portuguese label.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isLost, required this.backgroundColor});

  final bool isLost;
  final Color backgroundColor;

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
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isLost ? 'PERDIDO' : 'ENCONTRADO',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon with a small gray label above its wrapped value.
///
/// When [alignEnd] is true the column mirrors to the trailing edge, so the
/// date sits flush right while the local stays flush left.
class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.icon,
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final alignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          softWrap: true,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Formats [date] as dd/MM/yyyy in local time.
///
/// Returns 'Não informada' for [LostFoundItem.unknownCreatedAt] so legacy
/// records and pending server timestamps keep the two-column alignment
/// instead of collapsing the date column.
String _formatDate(DateTime date) {
  if (date.isAtSameMomentAs(LostFoundItem.unknownCreatedAt)) {
    return 'Não informada';
  }
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
