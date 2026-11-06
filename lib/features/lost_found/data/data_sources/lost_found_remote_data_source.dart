import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lost_found_item_model.dart';

class LostFoundRemoteDataSource {
  LostFoundRemoteDataSource(this._db);

  final FirebaseFirestore _db;

  Future<List<LostFoundItemModel>> getAll() async {
    final snapshot = await _db.collection('items').get();

    return snapshot.docs.map(LostFoundItemModel.fromFirestore).toList();
  }

  String generateId() => _db.collection('items').doc().id;

  Future<void> create(LostFoundItemModel model) async {
    if (model.id.isEmpty) {
      throw ArgumentError('Creation requires an operation ID.');
    }
    final document = _db.collection('items').doc(model.id);
    await _db.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(document);
      if (!snapshot.exists) {
        transaction.set(document, model.toMap());
        return;
      }

      final data = snapshot.data()!;
      // A previous commit may have succeeded without reaching the caller.
      // Confirm its original payload without regenerating the server timestamp.
      if (data['name'] != model.name ||
          data['description'] != model.description ||
          data['location'] != model.location ||
          data['status'] != model.status ||
          data['created_at'] is! Timestamp) {
        throw StateError('Existing document does not match the operation.');
      }
    });
  }
}
