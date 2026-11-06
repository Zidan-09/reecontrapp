import '../entities/lost_found_item.dart';

abstract interface class LostFoundRepository {
  Future<List<LostFoundItem>> getAll();

  /// Allocates an operation identity without writing a document.
  Future<String> generateId();

  /// Creates or confirms the same operation identified by [LostFoundItem.id].
  Future<void> create(LostFoundItem item);
}
