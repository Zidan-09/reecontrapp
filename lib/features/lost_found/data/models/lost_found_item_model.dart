import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';

class LostFoundItemModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String status;
  final DateTime createdAt;

  const LostFoundItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  factory LostFoundItemModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    final name = map['name'];
    final description = map['description'];
    final location = map['location'];
    final status = map['status'];
    if (name is! String ||
        description is! String ||
        location is! String ||
        status is! String) {
      throw const FormatException('Invalid lost-found document fields.');
    }
    if (status != 'lost' && status != 'found') {
      throw FormatException('Unknown item status: $status.');
    }

    // created_at is written with FieldValue.serverTimestamp() (DATABASE.md).
    // A just-created document may still carry a null pending timestamp;
    // failing explicitly keeps a sync gap visible instead of hiding it.
    final createdAtValue = map['created_at'];
    final DateTime createdAt;
    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else {
      throw const FormatException('Missing document creation timestamp.');
    }

    return LostFoundItemModel(
      id: documentId,
      name: name,
      description: description,
      location: location,
      status: status,
      createdAt: createdAt,
    );
  }

  factory LostFoundItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return LostFoundItemModel.fromMap(doc.data() ?? {}, doc.id);
  }

  LostFoundItem toEntity() {
    final ItemStatus itemStatus;
    switch (status) {
      case 'lost':
        itemStatus = ItemStatus.lost;
      case 'found':
        itemStatus = ItemStatus.found;
      default:
        throw FormatException('Unknown item status: $status.');
    }

    return LostFoundItem(
      id: id,
      name: name,
      description: description,
      location: location,
      status: itemStatus,
      createdAt: createdAt,
    );
  }
}
