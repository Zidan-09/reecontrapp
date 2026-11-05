import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lost_found_item_model.dart';

class LostFoundRemoteDataSource {
  LostFoundRemoteDataSource(this._db);

  final FirebaseFirestore _db;

  Future<List<LostFoundItemModel>> getAll() async {
    final snapshot = await _db.collection('items').get();

    return snapshot.docs.map(LostFoundItemModel.fromFirestore).toList();
  }

  Future<void> create(LostFoundItemModel model) async {
    await _db.collection('items').add(model.toMap());
  }
}
