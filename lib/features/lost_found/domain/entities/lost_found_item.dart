import '../enums/item_status.dart';

class LostFoundItem {
  /// Unknown creation time for legacy records or pending server timestamps.
  /// This sentinel is not an actual registration date and must not be displayed
  /// as one. It preserves the non-nullable [createdAt] contract.
  static final DateTime unknownCreatedAt = DateTime.utc(1970);

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
