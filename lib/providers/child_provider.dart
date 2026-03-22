import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child_profile_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

final selectedChildProvider = StateProvider<ChildProfileModel?>((ref) => null);

final childrenProvider = StreamProvider<List<ChildProfileModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).watchChildren(user.uid);
});
