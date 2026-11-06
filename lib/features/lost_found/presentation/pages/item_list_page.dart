import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reecontrapp/app/app_router.dart';
import 'package:reecontrapp/core/errors/communication_failure.dart';

import '../providers/item_list_provider.dart';
import '../widgets/lost_found_item_card.dart';

/// Listing screen (CARD-019, CARD-021).
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
/// Visual distinction of the situation (CARD-020), manual refresh
/// (CARD-022) and access to the registration form (CARD-023) are
/// handled in their own cards.
class ItemListPage extends ConsumerWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objetos perdidos e encontrados')),
      body: itemsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando registros...'),
            ],
          ),
        ),
        error: (error, stackTrace) {
          final message = error is CommunicationFailure
              ? error.userMessage
              : 'Não foi possível concluir a operação. Tente novamente.';

          return Center(
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
            return const Center(child: Text('Nenhum registro encontrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return LostFoundItemCard(item: items[index]);
            },
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
