import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../domain/entities/lost_found_item.dart';
import 'item_list_provider.dart';

/// Submission state for CARD-016.
///
/// Controls the form submission through [AsyncValue], using the same
/// state management tool as the listing (CARD-015: Riverpod):
///
/// - `AsyncData` before any submission: idle, form available;
/// - `AsyncLoading`: submission in progress;
/// - `AsyncData` after a successful write: registration completed;
/// - `AsyncError`: submission failed, holding the [CommunicationFailure]
///   from CARD-014 unchanged so the screen can show `failure.userMessage`
///   (Portuguese, without technical details).
///
/// The duplicate-submission guard lives here, not only in the button
/// (CARD-026/CARD-027): [submit] returns early while [state] is loading,
/// so fast repeated taps cannot trigger a second write before the
/// interface rebuilds. After an error a new [submit] call is allowed
/// without leaving the form. After success the listing is invalidated
/// with `ref.invalidate(itemListProvider)` so it reloads from the
/// cloud and shows the new record.
///
/// This file contains no widgets or navigation: screens only watch the
/// state with `ref.watch` and trigger [submit] with `ref.read`.
class CreateItemNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Idle: nothing submitted yet.
  }

  /// Submits [item] for cloud persistence.
  ///
  /// Calls received while a submission is in progress are ignored and
  /// never reach the use case, so no duplicate record is created.
  Future<void> submit(LostFoundItem item) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final createItem = ref.read(createLostFoundItemProvider);
      await createItem(item);

      ref.invalidate(itemListProvider);
    });
  }
}

/// Riverpod provider for the form submission state.
final createItemProvider = AsyncNotifierProvider<CreateItemNotifier, void>(
  CreateItemNotifier.new,
);
