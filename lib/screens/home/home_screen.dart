import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/child_provider.dart';
import '../../theme/app_theme.dart';
import '../widgets/child_avatar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final child = ref.watch(selectedChildProvider);
    final children = ref.watch(childrenProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.auto_stories, color: cs.primary, size: 22), const SizedBox(width: 8), const Text('Bedtime Stories', style: TextStyle(fontWeight: FontWeight.bold))]),
        actions: [
          IconButton(icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined), onPressed: () => ref.read(themeModeProvider.notifier).state = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => context.push('/profile')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          children.when(
            data: (list) => list.isEmpty
              ? Center(child: Column(children: [const SizedBox(height: 40), Icon(Icons.child_care, size: 64, color: cs.primary.withOpacity(0.4)), const SizedBox(height: 16), const Text('No child profiles yet'), const SizedBox(height: 12), FilledButton(onPressed: () => context.push('/add-child'), child: const Text('Add a child'))]))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Reading as', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                    ...list.map((c) => Padding(padding: const EdgeInsets.only(right: 10), child: ChildAvatar(child: c, isSelected: child?.id == c.id, onTap: () => ref.read(selectedChildProvider.notifier).state = c))),
                    GestureDetector(onTap: () => context.push('/add-child'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(border: Border.all(color: cs.outline.withOpacity(0.3)), borderRadius: BorderRadius.circular(40)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, size: 16, color: cs.primary), const SizedBox(width: 4), Text('Add', style: TextStyle(color: cs.primary, fontSize: 13))]))),
                  ])),
                ]),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(e.toString()),
          ),
          if (child != null) ...[
            const SizedBox(height: 32),
            Text('Good night, ${child.name}! 🌙', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Ready for a bedtime story?', style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
            const SizedBox(height: 28),
            _ActionCard(icon: Icons.auto_fix_high, title: 'Create new story', subtitle: 'AI generates a unique story just for you', color: cs.primary, onTap: () => context.push('/create-story')),
            const SizedBox(height: 14),
            _ActionCard(icon: Icons.favorite_outline, title: 'My favourite stories', subtitle: 'Your saved bedtime collection', color: const Color(0xFFE57373), onTap: () => context.push('/favorites')),
          ],
        ]),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon; final String title, subtitle; final Color color; final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 26)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55)))])),
        Icon(Icons.arrow_forward_ios, size: 14, color: color),
      ]),
    ),
  );
}
