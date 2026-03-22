import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/child_profile_model.dart';
import '../models/story_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async =>
      _db.collection('users').doc(user.id).set(user.toMap(), SetOptions(merge: true));

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> saveChildProfile(ChildProfileModel child) async =>
      _db.collection('children').doc(child.id).set(child.toMap());

  Stream<List<ChildProfileModel>> watchChildren(String parentId) => _db
      .collection('children')
      .where('parentId', isEqualTo: parentId)
      .snapshots()
      .map((s) => s.docs.map((d) => ChildProfileModel.fromMap(d.data())).toList());

  Future<void> saveFavoriteStory(StoryModel story) async =>
      _db.collection('stories').doc(story.id).set(story.toMap());

  Future<void> removeFavoriteStory(String storyId) async =>
      _db.collection('stories').doc(storyId).delete();

  Stream<List<StoryModel>> watchFavoriteStories(String childId) => _db
      .collection('stories')
      .where('childId', isEqualTo: childId)
      .where('isFavorite', isEqualTo: true)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => StoryModel.fromMap(d.data())).toList());

  Future<List<String>> getStorySummaries(String childId) async {
    final snap = await _db.collection('stories').where('childId', isEqualTo: childId).get();
    return snap.docs.map((d) => d.data()['title'] as String).toList();
  }
}
