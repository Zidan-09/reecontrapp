import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_router.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/theme_mode_provider.dart';
import '../../../../core/errors/communication_failure.dart';
import '../../domain/enums/item_status.dart';
import '../providers/item_list_provider.dart';
import '../widgets/lost_found_item_card.dart';

class ItemListPage extends ConsumerStatefulWidget {
  const ItemListPage({super.key});

  @override
  ConsumerState<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends ConsumerState<ItemListPage> {
  ItemStatus? _filter;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (ref.read(itemListProvider).isLoading) return;
    ref.invalidate(itemListProvider);
    try {
      await ref.read(itemListProvider.future);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemListProvider);
    final isUpdating = itemsAsync.isLoading;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text(
          'Achados\n& Perdidos',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            fontSize: 26,
            height: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          if (isUpdating)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Atualizar lista',
              onPressed: () {
                if (!ref.read(itemListProvider).isLoading) {
                  ref.invalidate(itemListProvider);
                }
              },
            ),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : themeMode == ThemeMode.light
                  ? Icons.dark_mode_rounded
                  : (isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded),
            ),
            tooltip: 'Alternar tema',
            onPressed: () {
              final current = ref.read(themeModeProvider);
              if (current == ThemeMode.system) {
                ref.read(themeModeProvider.notifier).state = isDark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              } else if (current == ThemeMode.light) {
                ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
              } else {
                ref.read(themeModeProvider.notifier).state = ThemeMode.light;
              }
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12,),
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) =>
                  setState(() => _searchQuery = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou local...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
              ),
            ),
          ),
          _FilterRow(
            selected: _filter,
            onSelected: (v) => setState(() => _filter = v),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'RECENTES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: _handleRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  ...itemsAsync.when(
                    skipLoadingOnReload: true,
                    skipLoadingOnRefresh: true,
                    loading: () => [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        sliver: SliverList.separated(
                          itemCount: 4,
                          separatorBuilder: (context, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, _) => const _SkeletonCard(),
                        ),
                      ),
                    ],
                    error: (error, _) => [
                      SliverFillRemaining(
                        child: _ErrorView(
                          message: toCommunicationFailure(error).userMessage,
                          onRetry: () => ref.invalidate(itemListProvider),
                        ),
                      ),
                    ],
                    data: (items) {
                      final filtered = items.where((i) {
                        final statusOk = _filter == null || i.status == _filter;
                        if (!statusOk) return false;
                        if (_searchQuery.isEmpty) return true;
                        return i.name.toLowerCase().contains(_searchQuery) ||
                            i.location.toLowerCase().contains(_searchQuery);
                      }).toList();
                      if (filtered.isEmpty) {
                        final hasSearch = _searchQuery.isNotEmpty;
                        return [
                          SliverFillRemaining(
                            child: hasSearch
                                ? _EmptyView(
                                    filter: _filter,
                                    message:
                                        'Nenhum resultado para "$_searchQuery".',
                                  )
                                : _EmptyView(filter: _filter),
                          ),
                        ];
                      }
                      return [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          sliver: SliverList.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (context, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                LostFoundItemCard(item: filtered[i]),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.createItem),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Cadastrar objeto'),
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onSelected});
  final ItemStatus? selected;
  final void Function(ItemStatus?) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _Chip(
              label: 'Todos',
              icon: Icons.list_rounded,
              selected: selected == null,
              activeColor: AppTheme.primaryBlue,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: 8),
            _Chip(
              label: 'Perdidos',
              dotColor: AppTheme.lost,
              selected: selected == ItemStatus.lost,
              activeColor: AppTheme.lost,
              onTap: () => onSelected(ItemStatus.lost),
            ),
            const SizedBox(width: 8),
            _Chip(
              label: 'Encontrados',
              dotColor: AppTheme.found,
              selected: selected == ItemStatus.found,
              activeColor: AppTheme.found,
              onTap: () => onSelected(ItemStatus.found),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.onTap,
    this.icon,
    this.dotColor,
  });
  final String label;
  final bool selected;
  final Color activeColor;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Keep dot always visible to avoid size jump; when selected dot becomes white for contrast
    final showDot = dotColor != null;
    final dot = showDot
        ? Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: selected ? Colors.white : dotColor,
              shape: BoxShape.circle,
            ),
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? activeColor : cs.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? activeColor : cs.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: selected ? Colors.white : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
            ],
            if (showDot) ...[dot!, const SizedBox(width: 6)],
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Estados ───────────────────────────────────────────────────

/// Placeholder com o mesmo tamanho de [LostFoundItemCard] para o
/// carregamento inicial não parecer "tela travada".
class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.35,
        end: 0.9,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        height: 94,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Bar(width: double.infinity, height: 14, cs: cs),
                ),
                const SizedBox(width: 12),
                _Bar(width: 72, height: 20, cs: cs, radius: 100),
              ],
            ),
            _Bar(width: 140, height: 11, cs: cs),
            _Bar(width: double.infinity, height: 11, cs: cs),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.width,
    required this.height,
    required this.cs,
    this.radius = 6,
  });
  final double width;
  final double height;
  final ColorScheme cs;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cs.onSurfaceVariant.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: cs.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Sem conexão',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({this.filter, this.message});
  final ItemStatus? filter;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = filter == ItemStatus.lost
        ? 'Nenhum objeto perdido'
        : filter == ItemStatus.found
        ? 'Nenhum objeto encontrado'
        : 'Nenhum registro ainda';
    final sub =
        message ??
        (filter == null
            ? 'Cadastre o primeiro usando o botão abaixo.'
            : 'Tente outro filtro ou cadastre um novo objeto.');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: cs.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: tt.titleMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
