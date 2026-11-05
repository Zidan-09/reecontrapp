import '../../../../core/errors/communication_failure.dart';
import '../../domain/entities/lost_found_item.dart';
import '../../domain/repositories/lost_found_repository.dart';
import '../data_sources/lost_found_remote_data_source.dart';
import '../models/lost_found_item_model.dart';

class LostFoundRepositoryImpl implements LostFoundRepository {
  LostFoundRepositoryImpl(this._dataSource);

  final LostFoundRemoteDataSource _dataSource;

  @override
  Future<List<LostFoundItem>> getAll() async {
    try {
      final models = await _dataSource.getAll();

      final items = models.map((model) => model.toEntity()).toList();
      items.sort((first, second) {
        final firstHasUnknownDate = first.createdAt.isAtSameMomentAs(
          LostFoundItem.unknownCreatedAt,
        );
        final secondHasUnknownDate = second.createdAt.isAtSameMomentAs(
          LostFoundItem.unknownCreatedAt,
        );

        // Unknown dates belong last, regardless of the sentinel's numeric value.
        if (firstHasUnknownDate != secondHasUnknownDate) {
          return firstHasUnknownDate ? 1 : -1;
        }

        final dateComparison = second.createdAt.compareTo(first.createdAt);
        if (dateComparison != 0) return dateComparison;

        // Document IDs make ties independent of the remote response order.
        return first.id.compareTo(second.id);
      });

      return items;
    } catch (error) {
      throw toCommunicationFailure(error);
    }
  }

  @override
  Future<void> create(LostFoundItem item) async {
    try {
      final model = LostFoundItemModel.fromEntity(item);

      await _dataSource.create(model);
    } catch (error) {
      throw toCommunicationFailure(error);
    }
  }
}
