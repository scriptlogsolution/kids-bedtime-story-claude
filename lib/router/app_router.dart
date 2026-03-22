import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/language_select_screen.dart';
import '../screens/onboarding/auth_screen.dart';
import '../screens/onboarding/add_child_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/story/create_story_screen.dart';
import '../screens/story/story_reading_screen.dart';
import '../screens/library/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../models/story_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuth = authState.valueOrNull != null;
      final onAuth = state.matchedLocation == '/auth' ||
          state.matchedLocation == '/language' ||
          state.matchedLocation == '/splash';
      if (!isAuth && !onAuth) return '/splash';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/language', builder: (c, s) => const LanguageSelectScreen()),
      GoRoute(path: '/auth', builder: (c, s) => const AuthScreen()),
      GoRoute(path: '/add-child', builder: (c, s) => const AddChildScreen()),
      GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/create-story', builder: (c, s) => const CreateStoryScreen()),
      GoRoute(
        path: '/story-reading',
        builder: (c, s) {
          final story = s.extra as StoryModel;
          return StoryReadingScreen(story: story);
        },
      ),
      GoRoute(path: '/favorites', builder: (c, s) => const FavoritesScreen()),
      GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
    ],
  );
});
