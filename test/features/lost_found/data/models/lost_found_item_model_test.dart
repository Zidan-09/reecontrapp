import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reecontrapp/features/lost_found/data/models/lost_found_item_model.dart';
import 'package:reecontrapp/features/lost_found/domain/entities/lost_found_item.dart';
import 'package:reecontrapp/features/lost_found/domain/enums/item_status.dart';

void main() {
  Map<String, dynamic> document() => {
    'name': 'Mochila',
    'description': 'Mochila azul',
    'location': 'Biblioteca',
    'status': 'lost',
  };

  group('CARD-012 creation timestamp', () {
    test('create requests server time regardless of the entity date', () {
      for (final date in [
        LostFoundItem.unknownCreatedAt,
        DateTime.utc(2099, 1, 1),
      ]) {
        final item = LostFoundItem(
          id: 'local-id',
          name: 'Mochila',
          description: 'Mochila azul',
          location: 'Biblioteca',
          status: ItemStatus.lost,
          createdAt: date,
        );

        final payload = LostFoundItemModel.fromEntity(item).toMap();

        expect(payload, {
          ...document(),
          'created_at': FieldValue.serverTimestamp(),
        });
        expect(payload.containsKey('id'), isFalse);
      }
    });

    test('read preserves the stored instant and all fields in the entity', () {
      final instant = DateTime.utc(2026, 11, 4, 15, 30, 45, 123, 456);
      final data = {
        ...document(),
        'created_at': Timestamp.fromDate(instant),
      };

      final model = LostFoundItemModel.fromMap(data, 'document-id');
      final item = model.toEntity();

      expect(model.createdAt, instant);
      expect(item.createdAt, instant);
      expect(item.createdAt.isUtc, isTrue);
      expect(item.id, 'document-id');
      expect(item.name, data['name']);
      expect(item.description, data['description']);
      expect(item.location, data['location']);
      expect(item.status, ItemStatus.lost);
      expect(
        LostFoundItemModel.fromMap(data, 'document-id').toEntity().createdAt,
        instant,
      );
    });

    test('missing timestamp keeps a legacy record readable', () {
      final data = document();
      final item = LostFoundItemModel.fromMap(data, 'legacy-id').toEntity();

      expect(item.createdAt, LostFoundItem.unknownCreatedAt);
      expect(item.id, 'legacy-id');
      expect(data.containsKey('created_at'), isFalse);
    });

    test('null timestamp stays unknown until a resolved read', () {
      final data = {...document(), 'created_at': null};
      final pending = LostFoundItemModel.fromMap(data, 'pending-id');
      expect(pending.toEntity().createdAt, LostFoundItem.unknownCreatedAt);

      final instant = DateTime.utc(2026, 11, 4, 16);
      final resolved = LostFoundItemModel.fromMap({
        ...data,
        'created_at': Timestamp.fromDate(instant),
      }, 'pending-id');
      expect(resolved.toEntity().createdAt, instant);
      expect(data['created_at'], isNull);
    });

    test('non-null timestamps with invalid types are rejected', () {
      for (final value in <Object>['2026-11-04', 123, true]) {
        expect(
          () => LostFoundItemModel.fromMap({
            ...document(),
            'created_at': value,
          }, 'invalid-id'),
          throwsFormatException,
        );
      }
    });
  });
}
