import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../domain/entities/lost_found_item.dart';

/// Listing state for CARD-015.
///
/// Holds the loaded items and exposes the loading, success and error
/// states through [AsyncValue]. The initial load and every refresh run
/// the [getLostFoundItemsProvider] use case, so reading and refreshing
/// are both asynchronous operations that never block the interface.
///
/// Usage:
/// - load happens automatically when the list is watched with
///   `ref.watch(itemListProvider)`;
/// - refresh with `ref.invalidate(itemListProvider)` (or `ref.refresh`
///   when the new items are needed immediately). Invalidating while a
///   load is still in flight simply restarts the load; Riverpod keeps
///   a single [AsyncValue], so sequential actions cannot leave the
///   state inconsistent.
///
/// Failures thrown by the repository are [CommunicationFailure] values
/// from CARD-014. They reach the interface unchanged as
/// `AsyncError.error`, so the screen can show `failure.userMessage`
/// (Portuguese, without technical details). A new load after a failure
/// goes back through loading and then settles into data or error again.
///
/// This file contains no widgets or navigation: screens only react to
/// the state with `ref.watch` and are rebuilt automatically.
final itemListProvider = FutureProvider<List<LostFoundItem>>((ref) async {
  final getItems = ref.watch(getLostFoundItemsProvider);

  return getItems();
});
