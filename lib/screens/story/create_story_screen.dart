import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/child_provider.dart';
import '../../providers/story_provider.dart';
import '../../models/story_model.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});
  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  String _storyType = 'Adventure', _mood = 'calm';
  static const _types = ['Adventure', 'Fantasy', 'Moral', 'Animals', 'Space', 'Friendship'];
  static const _moods = ['calm', 'funny', 'adventurous', 'magical'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final child = ref.watch(selectedChildProvider);
    final isGenerating = ref.watch(isGeneratingProvider);
    final stories = ref.watch(storyOptionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create story')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (child == null) const Center(child: Text('Please select a child first.'))
          else ...[
            Text('A story for ${child.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Story type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: _types.map((t) => ChoiceChip(label: Text(t), selected: _storyType == t, onSelected: (_) => setState(() => _storyType = t))).toList()),
            const SizedBox(height: 20),
            const Text('Mood', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: _moods.map((m) => ChoiceChip(label: Text(m), selected: _mood == m, onSelected: (_) => setState(() => _mood = m))).toList()),
            const SizedBox(height: 28),
            if (stories.isEmpty) SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(
              onPressed: isGenerating ? null : () => ref.read(storyControllerProvider).generateStories(child: child, storyType: _storyType, mood: _mood),
              icon: isGenerating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_fix_high),
              label: Text(isGenerating ? 'Crafting stories…' : 'Generate 3 story options'),
            )),
            if (stories.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Choose a story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...stories.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () { ref.read(storyOptionsProvider.notifier).state = []; context.push('/story-reading', extra: s); },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: cs.primary.withOpacity(0.3)), borderRadius: BorderRadius.circular(14), color: cs.primaryContainer.withOpacity(0.15)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 6),
                      Text(s.preview, style: TextStyle(color: cs.onSurface.withOpacity(0.6), fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(children: [Icon(Icons.touch_app, size: 14, color: cs.primary), const SizedBox(width: 4), Text('Tap to read', style: TextStyle(fontSize: 12, color: cs.primary, fontWeight: FontWeight.w500))]),
                    ]),
                  ),
                ),
              )),
              TextButton(onPressed: () => ref.read(storyControllerProvider).generateStories(child: child, storyType: _storyType, mood: _mood), child: const Text('Generate different options')),
            ],
          ],
        ]),
      ),
    );
  }
}
