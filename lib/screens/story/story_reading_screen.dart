import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/story_model.dart';
import '../../providers/story_provider.dart';
import '../../services/tts_service.dart';

class StoryReadingScreen extends ConsumerStatefulWidget {
  final StoryModel story;
  const StoryReadingScreen({super.key, required this.story});
  @override
  ConsumerState<StoryReadingScreen> createState() => _StoryReadingScreenState();
}

class _StoryReadingScreenState extends ConsumerState<StoryReadingScreen> {
  double _fontSize = 17;
  bool _isFavorite = false;
  TtsState _ttsState = TtsState.stopped;
  late StoryModel _story;

  @override
  void initState() { super.initState(); _story = widget.story; _isFavorite = _story.isFavorite; }

  @override
  void dispose() { ref.read(ttsServiceProvider).stop(); super.dispose(); }

  Future<void> _toggleAudio() async {
    final tts = ref.read(ttsServiceProvider);
    if (_ttsState == TtsState.playing) { await tts.stop(); setState(() => _ttsState = TtsState.stopped); }
    else { await tts.speak(_story.content, _story.language); setState(() => _ttsState = TtsState.playing); }
  }

  Future<void> _toggleFavorite() async {
    await ref.read(storyControllerProvider).toggleFavorite(_story);
    setState(() { _isFavorite = !_isFavorite; _story = _story.copyWith(isFavorite: _isFavorite); });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isFavorite ? 'Added to favourites ⭐' : 'Removed from favourites'), duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_story.title, style: const TextStyle(fontSize: 16)),
        actions: [IconButton(icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : null), onPressed: _toggleFavorite)],
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _Chip(_story.language, cs.primary),
              const SizedBox(width: 8), _Chip(_story.storyType, cs.secondary),
              const SizedBox(width: 8), _Chip(_story.mood, cs.tertiary),
            ]),
            const SizedBox(height: 20),
            Text(_story.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3, color: cs.primary)),
            const SizedBox(height: 20),
            Text(_story.content, style: TextStyle(fontSize: _fontSize, height: 1.85, letterSpacing: 0.2)),
            const SizedBox(height: 40),
            Center(child: Text('🌙 The End 🌙', style: TextStyle(fontSize: 18, color: cs.onSurface.withOpacity(0.4)))),
          ]),
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(color: cs.surface, border: Border(top: BorderSide(color: cs.outline.withOpacity(0.15)))),
          child: Row(children: [
            const Icon(Icons.text_fields, size: 16),
            Expanded(child: Slider(value: _fontSize, min: 13, max: 24, onChanged: (v) => setState(() => _fontSize = v))),
            const SizedBox(width: 12),
            FilledButton.icon(onPressed: _toggleAudio, icon: Icon(_ttsState == TtsState.playing ? Icons.pause : Icons.play_arrow, size: 18), label: Text(_ttsState == TtsState.playing ? 'Pause' : 'Listen')),
          ]),
        ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
  );
}
