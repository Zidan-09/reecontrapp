import '../../domain/entities/lost_found_item.dart';
import '../../domain/repositories/lost_found_repository.dart';
import '../data_sources/lost_found_remote_data_source.dart';

class LostFoundRepositoryImpl implements LostFoundRepository {
  LostFoundRepositoryImpl(this._dataSource);

  final LostFoundRemoteDataSource _dataSource;

  @override
  Future<List<LostFoundItem>> getAll() async {
    final models = await _dataSource.getAll();

    return models.map((model) => model.toEntity()).toList();
  }
}
