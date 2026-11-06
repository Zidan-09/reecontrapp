import '../../domain/entities/lost_found_item.dart';
import '../../domain/repositories/lost_found_repository.dart';

class CreateLostFoundItem {
  CreateLostFoundItem(this._repository);

  final LostFoundRepository _repository;

  Future<String> generateId() => _repository.generateId();

  Future<void> call(LostFoundItem item) {
    return _repository.create(item);
  }
}
