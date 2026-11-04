import '../../domain/entities/lost_found_item.dart';
import '../../domain/repositories/lost_found_repository.dart';

class GetLostFoundItems {
  GetLostFoundItems(this._repository);

  final LostFoundRepository _repository;

  Future<List<LostFoundItem>> call() {
    return _repository.getAll();
  }
}
