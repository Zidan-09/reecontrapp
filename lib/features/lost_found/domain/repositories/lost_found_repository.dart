import '../entities/lost_found_item.dart';

abstract interface class LostFoundRepository {
  Future<List<LostFoundItem>> getAll();

  Future<void> create(LostFoundItem item);
}
