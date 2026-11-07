import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reecontrapp/app/app_router.dart';
import 'package:reecontrapp/core/errors/communication_failure.dart';

import '../providers/item_list_provider.dart';
import '../widgets/lost_found_item_card.dart';

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
/// here: the initial load shows a loading indicator, a read failure
/// shows only the comprehensible message from CARD-014
/// ([CommunicationFailure.userMessage], in Portuguese, without
/// technical details) with a visible action to try again, and every
/// retry goes back through loading before settling into data or a
/// new error. The error view never shows a stale list.
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
      appBar: AppBar(
        title: const Text(
          'Objetos perdidos e encontrados',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
      body: itemsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () => const _CenteredScrollable(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando registros...', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        error: (error, stackTrace) {
          final message = error is CommunicationFailure
              ? error.userMessage
              : 'Não foi possível concluir a operação. Tente novamente.';

          return _CenteredScrollable(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => ref.invalidate(itemListProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (items) {
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: handleRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: const Center(
                      child: Text('Nenhum registro encontrado.'),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (isUpdating) const LinearProgressIndicator(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return LostFoundItemCard(item: items[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.createItem),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar objeto'),
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
  const _CenteredScrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
