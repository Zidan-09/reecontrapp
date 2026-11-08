import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reecontrapp/app/app_router.dart';
import 'package:reecontrapp/core/errors/communication_failure.dart';

import '../providers/item_list_provider.dart';
import '../widgets/lost_found_item_card.dart';

/// Flat light-gray background matching `docs/design/card-design-idea.jpg`.
const _listBackground = Color(0xFFF0F0F0);

/// Listing screen (CARD-019, CARD-021, CARD-022).
///
/// Consumes the listing state from CARD-015 through [itemListProvider]
/// and loads the cloud records when opened. Each record shows name,
/// location, situation and description in the same scrollable list
/// for lost and found objects, using Material 3 components.
///
/// This screen never accesses the cloud service directly and defines
/// no data inline: every item comes from the provider.
///
/// Loading and error with retry belong to CARD-021 and are handled
/// here: the initial load shows skeleton cards matching the final
/// layout, a read failure shows only the comprehensible message from
/// CARD-014 ([CommunicationFailure.userMessage], in Portuguese,
/// without technical details) with a visible action to try again, and
/// every retry goes back through loading before settling into data or
/// a new error. The error view never shows a stale list.
///
/// Manual refresh (CARD-022) re-reads the cloud through the same
/// CARD-015 action (`ref.invalidate(itemListProvider)`), so records
/// created by other installations appear afterwards in the
/// repository order (newest first).
/// Decision (ambiguity A5, RNF01.4): expose both an always-visible
/// "Atualizar lista" button in the [AppBar] and the Material
/// pull-to-refresh gesture ([RefreshIndicator]). The button alone
/// guarantees discoverability; the gesture is a common complement.
/// While a load is in flight the button is disabled and both
/// callbacks return early on `isLoading`, so repeated taps never
/// start simultaneous reads. Reloads keep the list visible
/// (`skipLoadingOnReload/Refresh`) with a [LinearProgressIndicator]
/// at the top, and a failed refresh falls back to the CARD-014
/// error view.
///
/// Visual distinction of the situation (CARD-020) is handled in its
/// own card. Access to the registration form (CARD-023) is a
/// Material 3 [FloatingActionButton.extended] labeled in Portuguese,
/// kept on the [Scaffold] so it stays visible without scrolling in
/// loading, error, empty and data states, including long lists. The
/// list keeps extra bottom padding so the button never covers the
/// essential content of the last item.
class ItemListPage extends ConsumerWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemListProvider);
    final isUpdating = itemsAsync.isLoading;

    Future<void> handleRefresh() async {
      if (ref.read(itemListProvider).isLoading) {
        return;
      }
      ref.invalidate(itemListProvider);
      try {
        // ignore: unused_result, handled through itemListProvider state.
        await ref.read(itemListProvider.future);
      } catch (_) {
        // Failure stays exposed through itemListProvider; the error
        // view below shows the CARD-014 message with a retry action.
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Achados e Perdidos',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar lista',
            onPressed: isUpdating
                ? null
                : () {
                    if (ref.read(itemListProvider).isLoading) {
                      return;
                    }
                    ref.invalidate(itemListProvider);
                  },
          ),
        ],
      ),
      body: ColoredBox(
        color: _listBackground,
        child: SafeArea(
          bottom: false,
          child: itemsAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            loading: () => const _LoadingList(),
            error: (error, stackTrace) {
              final message = toCommunicationFailure(error).userMessage;

              return _ErrorView(
                message: message,
                onRetry: () => ref.invalidate(itemListProvider),
              );
            },
            data: (items) {
              if (items.isEmpty) {
                return _EmptyView(onRefresh: handleRefresh);
              }

              return Column(
                children: [
                  if (isUpdating) const LinearProgressIndicator(),
                  ColoredBox(
                    color: Colors.white,
                    child: _ListHeader(count: items.length),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: _listBackground,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: RefreshIndicator(
                            onRefresh: handleRefresh,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                96,
                              ),
                              itemCount: items.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return LostFoundItemCard(item: items[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.createItem),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar objeto'),
      ),
    );
  }
}

/// Summary shown above the list: how many records exist and their order.
///
/// Both values come from the already loaded list, so no extra reads or
/// filters are introduced. It answers "is this everything?" at a glance
/// and sets the expectation that the newest records come first.
class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final countLabel = count == 1 ? '1 objeto' : '$count objetos';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      countLabel,
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mais recentes primeiro',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Initial loading state as skeleton cards.
///
/// The placeholders mirror the shape of [LostFoundItemCard] (status pill,
/// title, location and description lines) so the layout does not jump
/// when the data arrives. Static blocks are used on purpose: no extra
/// animation cost and no motion-sensitivity issues.
class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 88, 16, 96),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholder = colorScheme.surfaceContainerHigh;

    Widget bar({required double width, required double height}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholder,
          borderRadius: BorderRadius.circular(999),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                bar(width: 48, height: 12),
                const Spacer(),
                Container(
                  width: 110,
                  height: 28,
                  decoration: BoxDecoration(
                    color: placeholder,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            bar(width: 200, height: 20),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bar(width: 80, height: 12),
                      const SizedBox(height: 8),
                      bar(width: 120, height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      bar(width: 80, height: 12),
                      const SizedBox(height: 8),
                      bar(width: 100, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            bar(width: 80, height: 12),
            const SizedBox(height: 8),
            bar(width: double.infinity, height: 12),
            const SizedBox(height: 6),
            bar(width: double.infinity, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Empty state: teaches what belongs here and surfaces the existing
/// registration action. The button navigates to the same route as the
/// floating action button, so no new behavior is introduced.
class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 88, 24, 96),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 24,
                            offset: Offset(0, 12),
                            color: Color(0x33000000),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search_outlined,
                              size: 32,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Nenhum objeto por aqui ainda',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Quando alguém da comunidade cadastrar um objeto '
                            'perdido ou encontrado, ele aparece nesta lista.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () =>
                                Navigator.of(context)
                                    .pushNamed(AppRouter.createItem),
                            icon: const Icon(Icons.add),
                            label: const Text('Cadastrar objeto'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Error state: shows only the user-facing CARD-014 message with a clear
/// recovery action, keeping the same visual language as the empty state.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return _CenteredScrollable(
      topPadding: 88,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(0, 12),
                  color: Color(0x33000000),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_off_outlined,
                    size: 32,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Não foi possível carregar a lista',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Centers [child] while keeping room to scroll on short viewports.
///
/// CARD-029: loading and error states must stay reachable in landscape
/// or with enlarged text, without layout overflow. Fills at least the
/// available height and scrolls when the content does not fit.
class _CenteredScrollable extends StatelessWidget {
  const _CenteredScrollable({required this.child, this.topPadding = 0});

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(top: topPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - topPadding).clamp(
                0.0,
                double.infinity,
              ),
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
