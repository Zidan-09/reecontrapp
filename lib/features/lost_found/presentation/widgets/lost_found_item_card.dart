import 'package:flutter/material.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';
import '../../../../app/app_theme.dart';

/// Linhas de descrição visíveis com o card recolhido.
const _collapsedDescriptionLines = 2;

/// Meses em português para a data do card ("7 de Novembro, 2026").
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

/// Formata [date] como "7 de Novembro, 2026" no horário local.
///
/// Retorna 'Não informada' para [LostFoundItem.unknownCreatedAt] e para
/// timestamps ainda não resolvidos pelo servidor.
String _formatDate(DateTime date) {
  if (date.isAtSameMomentAs(LostFoundItem.unknownCreatedAt)) {
    return 'Não informada';
  }
  final local = date.toLocal();
  final month = _monthNames[local.month - 1];
  return '${local.day} de $month, ${local.year}';
}

class LostFoundItemCard extends StatefulWidget {
  const LostFoundItemCard({super.key, required this.item});

  final LostFoundItem item;

  @override
  State<LostFoundItemCard> createState() => _LostFoundItemCardState();
}

class _LostFoundItemCardState extends State<LostFoundItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isLost = widget.item.status == ItemStatus.lost;

    final stripeColor = isLost ? AppTheme.lost : AppTheme.found;
    // Tags seguem as mesmas cores dos chips de filtro: fundo
    // AppTheme.lost/found e texto branco, nos dois modos de tema.
    final badgeColor = Colors.white;
    final badgeBg = isLost ? AppTheme.lost : AppTheme.found;
    final badgeIcon = isLost
        ? Icons.search_rounded
        : Icons.check_circle_rounded;
    final badgeLabel = isLost ? 'Perdido' : 'Encontrado';

    final item = widget.item;

    final borderSide = BorderSide(
      color: cs.outlineVariant.withValues(alpha: 0.6),
      width: 0.5,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // surfaceContainerHighest fica ~#2E2F38 no dark com seed 0xFF0F4C75 —
    // visível, mas o texto precisa de cor explícita para não sumir.
    final titleColor = isDark ? cs.onSurface : Colors.black87;
    final bodyColor = isDark
        ? const Color(0xFFB8BEC9)
        : const Color(0xFF5A6472);

    // O Flutter proíbe borderRadius combinado com borda de cores diferentes
    // ("borderRadius can only be given on borders with uniform colors"):
    // a exceção no paint fazia o conteúdo do card não ser pintado. Borda
    // uniforme + stripe desenhado por cima mantém o mesmo visual.
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHighest : Colors.white,
              border: Border.all(color: borderSide.color, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(badgeIcon, size: 11, color: badgeColor),
                            const SizedBox(width: 4),
                            Text(
                              badgeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: badgeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: stripeColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: tt.bodySmall?.copyWith(color: bodyColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: stripeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(item.createdAt),
                        style: tt.bodySmall?.copyWith(color: bodyColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _DescriptionSection(
                      description: item.description,
                      expanded: _expanded,
                      style: tt.bodyMedium?.copyWith(
                        color: bodyColor,
                        height: 1.5,
                      ),
                      onToggle: () => setState(() => _expanded = !_expanded),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: stripeColor),
          ),
        ],
      ),
    );
  }
}

/// Descrição limitada a [_collapsedDescriptionLines] linhas com um botão
/// outlined de largura total ("MAIS DETALHES" / "MENOS DETALHES").
///
/// O botão só aparece quando o texto realmente estoura o limite colapsado
/// (medido com [TextPainter]), então descrições curtas mantêm o card
/// compacto e a expansão não depende de clique no card.
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({
    required this.description,
    required this.expanded,
    required this.style,
    required this.onToggle,
  });

  final String description;
  final bool expanded;
  final TextStyle? style;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Text(
                description,
                softWrap: true,
                maxLines: expanded ? null : _collapsedDescriptionLines,
                overflow: expanded ? null : TextOverflow.ellipsis,
                style: style,
              ),
            ),
            if (showToggle) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onToggle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
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

/// Retorna true quando [text] precisa de mais de
/// [_collapsedDescriptionLines] linhas na largura informada.
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
