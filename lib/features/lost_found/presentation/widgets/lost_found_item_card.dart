import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

/// Neutral shadow for the white card over the flat `#F0F0F0` background,
/// matching `docs/design/card-design-idea.jpg`.
const _cardShadow = Color(0x1A000000);

/// Solid green for the "ENCONTRADO" badge.
///
/// [ColorScheme.error] already covers "PERDIDO" with theme contrast, but no
/// theme color maps cleanly to a solid "found" pill, so the value is fixed
/// to keep lost/found distinguishable by label, dot and hue.
const _foundBadge = Color(0xFF2E7D32);

/// Lines of description visible while the card is collapsed.
///
/// Bounds the card height so long descriptions end with "..." instead of
/// stretching the card. Tapping "MAIS DETALHES" removes the limit.
const _collapsedDescriptionLines = 2;

/// Card of a single object in the listing.
///
/// Follows `docs/design/card-design-idea.jpg` without the object photo
/// (image upload is out of scope) and without the contact button (no
/// approved behavior yet): status row with a solid pill, bold title,
/// two-column local/date block, labeled description and the outlined
/// "MAIS DETALHES" button.
///
/// The expand/collapse state is purely visual and stays local to the card
/// ([State]), so no Riverpod state is involved.
class LostFoundItemCard extends StatefulWidget {
  const LostFoundItemCard({super.key, required this.item});

  final LostFoundItem item;

  @override
  State<LostFoundItemCard> createState() => _LostFoundItemCardState();
}

class _LostFoundItemCardState extends State<LostFoundItemCard> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLost = widget.item.status == ItemStatus.lost;

    final badgeColor = isLost ? colorScheme.error : _foundBadge;

    return Container(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 16, offset: Offset(0, 6)),
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
              widget.item.name,
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
                  child: _InfoColumn(
                    icon: Icons.place_outlined,
                    label: 'Local',
                    value: widget.item.location,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoColumn(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data',
                    value: _formatDate(widget.item.createdAt),
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
            _DescriptionSection(
              description: widget.item.description,
              expanded: _expanded,
              onToggle: _toggleExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

/// Description text clamped to [_collapsedDescriptionLines] with a
/// full-width outlined toggle, mirroring the design mock.
///
/// The button only appears when the text actually overflows the collapsed
/// limit (measured with [TextPainter] in the available width), so short
/// descriptions keep the card compact. While collapsed the text ends with
/// "..."; expanded it shows in full and the button reads "MENOS DETALHES".
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({
    required this.description,
    required this.expanded,
    required this.onToggle,
  });

  final String description;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final style = textTheme.bodyMedium?.copyWith(height: 1.5);
        final isOverflowing = _exceedsMaxLines(
          context,
          text: description,
          style: style,
          maxWidth: constraints.maxWidth,
        );
        final showToggle = isOverflowing || expanded;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              softWrap: true,
              maxLines: expanded ? null : _collapsedDescriptionLines,
              overflow: expanded ? null : TextOverflow.ellipsis,
              style: style,
            ),
            if (showToggle) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onToggle,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(expanded ? 'MENOS DETALHES' : 'MAIS DETALHES'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Returns true when [text] needs more than [_collapsedDescriptionLines]
/// in the given width, honoring the current text scale.
bool _exceedsMaxLines(
  BuildContext context, {
  required String text,
  required TextStyle? style,
  required double maxWidth,
}) {
  if (maxWidth <= 0) {
    return false;
  }
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: _collapsedDescriptionLines,
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout(maxWidth: maxWidth);
  return painter.didExceedMaxLines;
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
        borderRadius: BorderRadius.circular(10),
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

/// Portuguese month names for the card date, matching
/// `docs/design/card-design-idea.jpg` ("25 de Outubro, 2023").
///
/// Kept as a local list on purpose: the project has no date-formatting
/// dependency and a single usage does not justify adding one.
const _monthNames = <String>[
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Formats [date] as "25 de Outubro, 2023" in local time.
///
/// Returns 'Não informada' for [LostFoundItem.unknownCreatedAt] so legacy
/// records and pending server timestamps keep the two-column alignment
/// instead of collapsing the date column.
String _formatDate(DateTime date) {
  if (date.isAtSameMomentAs(LostFoundItem.unknownCreatedAt)) {
    return 'Não informada';
  }
  final local = date.toLocal();
  final month = _monthNames[local.month - 1];
  return '${local.day} de $month, ${local.year}';
}
