import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reecontrapp/app/app_router.dart';

import '../providers/item_list_provider.dart';
import '../widgets/lost_found_item_card.dart';

/// Listing screen (CARD-019).
///
/// Consumes the listing state from CARD-015 through [itemListProvider]
/// and loads the cloud records when opened. Each record shows name,
/// location, situation and description in the same scrollable list
/// for lost and found objects, using Material 3 components.
///
/// This screen never accesses the cloud service directly and defines
/// no data inline: every item comes from the provider.
///
/// Loading, error with retry (CARD-021), visual distinction of the
/// situation (CARD-020), manual refresh (CARD-022) and access to the
/// registration form (CARD-023) are handled in their own cards.
/// The states below are intentionally minimal so the screen stays
/// functional while those cards evolve.
class ItemListPage extends ConsumerWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objetos perdidos e encontrados')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Não foi possível carregar os registros.'),
        ),
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
