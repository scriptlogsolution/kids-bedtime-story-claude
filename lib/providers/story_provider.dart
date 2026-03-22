import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';
import '../models/child_profile_model.dart';
import '../services/story_service.dart';
import '../services/firestore_service.dart';

final storyOptionsProvider = StateProvider<List<StoryModel>>((ref) => []);
final isGeneratingProvider = StateProvider<bool>((ref) => false);

final favoriteStoriesProvider = StreamProvider.family<List<StoryModel>, String>((ref, childId) {
  return ref.read(firestoreServiceProvider).watchFavoriteStories(childId);
});

final storyControllerProvider = Provider<StoryController>((ref) => StoryController(ref));

class StoryController {
  final Ref _ref;
  StoryController(this._ref);

  Future<void> generateStories({required ChildProfileModel child, required String storyType, required String mood}) async {
    _ref.read(isGeneratingProvider.notifier).state = true;
    try {
      final summaries = await _ref.read(firestoreServiceProvider).getStorySummaries(child.id);
      final stories = await _ref.read(storyServiceProvider).generateStoryOptions(
        child: child, storyType: storyType, mood: mood, previousTitles: summaries,
      );
      _ref.read(storyOptionsProvider.notifier).state = stories;
    } finally {
      _ref.read(isGeneratingProvider.notifier).state = false;
    }
  }

  Future<void> toggleFavorite(StoryModel story) async {
    final fs = _ref.read(firestoreServiceProvider);
    if (story.isFavorite) {
      await fs.removeFavoriteStory(story.id);
    } else {
      await fs.saveFavoriteStory(story.copyWith(isFavorite: true));
    }
  }
}
