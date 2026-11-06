import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reecontrapp/features/lost_found/data/data_sources/lost_found_remote_data_source.dart';
import 'package:reecontrapp/features/lost_found/data/models/lost_found_item_model.dart';
import 'package:reecontrapp/features/lost_found/data/repositories/lost_found_repository_impl.dart';
import 'package:reecontrapp/features/lost_found/domain/entities/lost_found_item.dart';
import 'package:reecontrapp/features/lost_found/domain/enums/item_status.dart';

LostFoundItemModel item(String id, DateTime createdAt) {
  return LostFoundItemModel(
    id: id,
    name: 'Objeto $id',
    description: 'Descricao $id',
    location: 'Biblioteca',
    status: 'lost',
    createdAt: createdAt,
  );
}

class StubRemoteDataSource implements LostFoundRemoteDataSource {
  StubRemoteDataSource(this.models);

  List<LostFoundItemModel> models;

  @override
  Future<List<LostFoundItemModel>> getAll() async => models;

  @override
  String generateId() {
    throw UnsupportedError('ID allocation is not used by these read tests.');
  }

  @override
  Future<void> create(LostFoundItemModel model) async {
    throw UnsupportedError('Creation is not used by these read tests.');
  }
}

void main() {
  group('CARD-013 chronological ordering', () {
    test('sorts newest first and preserves fields and source', () async {
      final oldest = item('z', DateTime.utc(2026, 11, 4, 9));
      final middle = item('a', DateTime.utc(2026, 11, 4, 10));
      final newest = item('m', DateTime.utc(2026, 11, 4, 11));
      final source = List<LostFoundItemModel>.unmodifiable([
        middle,
        oldest,
        newest,
      ]);
      final repository = LostFoundRepositoryImpl(StubRemoteDataSource(source));

      final result = await repository.getAll();

      expect(result.map((entry) => entry.id), ['m', 'a', 'z']);
      expect(source, [middle, oldest, newest]);
      for (final model in source) {
        final entity = result.singleWhere((entry) => entry.id == model.id);
        expect(entity.name, model.name);
        expect(entity.description, model.description);
        expect(entity.location, model.location);
        expect(entity.status, ItemStatus.lost);
        expect(entity.createdAt, model.createdAt);
      }
    });

    test('keeps an empty list empty', () async {
      final repository = LostFoundRepositoryImpl(StubRemoteDataSource([]));

      expect(await repository.getAll(), isEmpty);
    });

    test('keeps a single record unchanged', () async {
      final model = item('only', DateTime.utc(2026, 11, 4));
      final repository = LostFoundRepositoryImpl(StubRemoteDataSource([model]));

      final result = await repository.getAll();

      expect(result, hasLength(1));
      expect(result.single.id, model.id);
      expect(result.single.createdAt, model.createdAt);
    });

    test('breaks equal-instant ties by ascending ID on every read', () async {
      final instant = DateTime.utc(2026, 11, 4, 12);
      final first = item('a', instant.toLocal());
      final second = item('b', instant);
      final source = StubRemoteDataSource([second, first]);
      final repository = LostFoundRepositoryImpl(source);

      expect((await repository.getAll()).map((entry) => entry.id), ['a', 'b']);
      source.models = [first, second];
      expect((await repository.getAll()).map((entry) => entry.id), ['a', 'b']);
    });

    test('keeps missing and null timestamps unchanged and last', () async {
      final fields = <String, dynamic>{
        'name': 'Objeto',
        'description': 'Descricao',
        'location': 'Biblioteca',
        'status': 'found',
      };
      final missing = LostFoundItemModel.fromMap(fields, 'a-missing');
      final pending = LostFoundItemModel.fromMap({
        ...fields,
        'created_at': null,
      }, 'b-pending');
      final dated = LostFoundItemModel.fromMap({
        ...fields,
        'created_at': Timestamp.fromDate(DateTime.utc(1960)),
      }, 'z-dated');
      final source = StubRemoteDataSource([pending, dated, missing]);
      final repository = LostFoundRepositoryImpl(source);

      final result = await repository.getAll();

      expect(result.map((entry) => entry.id), [
        'z-dated',
        'a-missing',
        'b-pending',
      ]);
      expect(result.first.createdAt, DateTime.utc(1960));
      expect(result[1].createdAt, LostFoundItem.unknownCreatedAt);
      expect(result[2].createdAt, LostFoundItem.unknownCreatedAt);
      expect(result.every((entry) => entry.status == ItemStatus.found), isTrue);
    });

    test('sorts shuffled reads and puts a new record first', () async {
      final oldest = item('oldest', DateTime.utc(2026, 11, 4, 9));
      final middle = item('middle', DateTime.utc(2026, 11, 4, 10));
      final newest = item('newest', DateTime.utc(2026, 11, 4, 11));
      final source = StubRemoteDataSource([middle, oldest, newest]);
      final repository = LostFoundRepositoryImpl(source);

      final firstRead = await repository.getAll();
      source.models = [newest, middle, oldest];
      final secondRead = await repository.getAll();
      expect(secondRead.map((entry) => entry.id), [
        'newest',
        'middle',
        'oldest',
      ]);

      final added = item('added', DateTime.utc(2026, 11, 4, 12));
      source.models = [oldest, added, middle, newest];
      final thirdRead = await repository.getAll();

      expect(thirdRead.map((entry) => entry.id), [
        'added',
        'newest',
        'middle',
        'oldest',
      ]);
      expect(firstRead.map((entry) => entry.id), [
        'newest',
        'middle',
        'oldest',
      ]);
      expect(identical(firstRead, secondRead), isFalse);
    });
  });
}
