import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/child_provider.dart';
import '../../providers/story_provider.dart';
import '../../models/story_model.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final child = ref.watch(selectedChildProvider);
    if (child == null) return const Scaffold(body: Center(child: Text('Select a child first')));
    final stories = ref.watch(favoriteStoriesProvider(child.id));
    return Scaffold(
      appBar: AppBar(title: Text("${child.name}'s favourites")),
      body: stories.when(
        data: (list) => list.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 64, color: cs.onSurface.withOpacity(0.2)), const SizedBox(height: 16), const Text('No favourites yet'), const SizedBox(height: 8), Text('Tap the heart while reading to save a story', style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 13))]))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final s = list[i];
                return InkWell(
                  onTap: () => context.push('/story-reading', extra: s),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: cs.outline.withOpacity(0.15))),
                    child: Row(children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(10)), child: Center(child: Icon(Icons.auto_stories, color: cs.primary, size: 22))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), const SizedBox(height: 3), Text('${s.language} • ${s.storyType}', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.5)))])),
                      const Icon(Icons.favorite, color: Colors.red, size: 18),
                    ]),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
