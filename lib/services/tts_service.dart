import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  final s = TtsService();
  ref.onDispose(s.dispose);
  return s;
});

enum TtsState { playing, paused, stopped }

class TtsService {
  final FlutterTts _tts = FlutterTts();
  TtsService() {
    _tts.setSpeechRate(0.45);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
  }
  Future<void> speak(String text, String language) async {
    final lang = switch (language) {
      'Hindi' => 'hi-IN', 'Gujarati' => 'gu-IN', 'Marathi' => 'mr-IN', _ => 'en-IN',
    };
    await _tts.setLanguage(lang);
    await _tts.speak(text);
  }
  Future<void> stop() async => _tts.stop();
  void dispose() => _tts.stop();
}
