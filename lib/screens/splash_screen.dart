import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final langSet = prefs.getBool('lang_set') ?? false;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) context.go('/home');
    else if (langSet) context.go('/auth');
    else context.go('/language');
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.auto_stories, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              Text('Bedtime Stories', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
              const SizedBox(height: 8),
              Text("Your child's personal storybook", style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
              const SizedBox(height: 48),
              CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
            ],
          ),
        ),
      ),
    );
  }
}
