import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/use_cases/get_lost_found_items.dart';
import '../domain/repositories/lost_found_repository.dart';
import 'data_sources/lost_found_remote_data_source.dart';
import 'repositories/lost_found_repository_impl.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final lostFoundRemoteDataSourceProvider = Provider<LostFoundRemoteDataSource>((
  ref,
) {
  return LostFoundRemoteDataSource(ref.watch(firestoreProvider));
});

final lostFoundRepositoryProvider = Provider<LostFoundRepository>((ref) {
  return LostFoundRepositoryImpl(ref.watch(lostFoundRemoteDataSourceProvider));
});

final getLostFoundItemsProvider = Provider<GetLostFoundItems>((ref) {
  return GetLostFoundItems(ref.watch(lostFoundRepositoryProvider));
});
