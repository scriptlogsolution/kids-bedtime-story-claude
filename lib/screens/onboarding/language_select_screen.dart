import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});
  static const _langs = [
    {'name': 'English', 'flag': '🇬🇧', 'native': 'English'},
    {'name': 'Hindi', 'flag': '🇮🇳', 'native': 'हिन्दी'},
    {'name': 'Gujarati', 'flag': '🇮🇳', 'native': 'ગુજરાતી'},
    {'name': 'Marathi', 'flag': '🇮🇳', 'native': 'मराठी'},
  ];

  Future<void> _select(BuildContext context, String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
    await prefs.setBool('lang_set', true);
    if (context.mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Choose your\nlanguage', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ...(_langs.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _select(context, l['name']!),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(border: Border.all(color: cs.outline.withOpacity(0.3)), borderRadius: BorderRadius.circular(16), color: cs.surface),
                    child: Row(children: [
                      Text(l['flag']!, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 16),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(l['native']!, style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 13)),
                      ]),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurface.withOpacity(0.3)),
                    ]),
                  ),
                ),
              ))),
            ],
          ),
        ),
      ),
    );
  }
}
