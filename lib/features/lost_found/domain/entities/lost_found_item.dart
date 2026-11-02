import '../enums/item_status.dart';

class LostFoundItem {
  final String id;
  final String name;
  final String description;
  final String location;
  final ItemStatus status;
  final DateTime createdAt;

  const LostFoundItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });
}
