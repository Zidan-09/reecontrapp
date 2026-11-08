import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lost_found_item_model.dart';

class LostFoundRemoteDataSource {
  LostFoundRemoteDataSource(this._db);

  final FirebaseFirestore _db;

  Future<List<LostFoundItemModel>> getAll() async {
    // Leitura inicial usa cache-then-server: mostra o que já está em cache
    // e completa com o servidor. Sem timeout próprio para não abortar uma
    // leitura lenta porém válida (o SDK já trata offline).
    final snapshot = await _db.collection('items').get();

    // Cache vazio não prova coleção vazia: numa instalação nova sem
    // conexão, o `get()` resolve do cache vazio como lista vazia e a
    // falha de comunicação seria mascarada como "Nenhum registro ainda"
    // (RF03.4/RF03.5). Confirma no servidor nesse caso ambíguo; se a
    // rede falhar, o erro vira CommunicationFailure e a tela exibe a
    // mensagem em português com nova tentativa.
    if (snapshot.metadata.isFromCache && snapshot.docs.isEmpty) {
      final server = await _db
          .collection('items')
          .get(const GetOptions(source: Source.server));
      return server.docs.map(LostFoundItemModel.fromFirestore).toList();
    }

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
