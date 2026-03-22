import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true, _loading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(authServiceProvider);
      if (_isLogin) {
        await auth.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
      } else {
        await auth.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim(), _nameCtrl.text.trim());
      }
      if (mounted) context.go('/add-child');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _google() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted) context.go('/add-child');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 40),
            const Icon(Icons.auto_stories, size: 40),
            const SizedBox(height: 16),
            Text(_isLogin ? 'Welcome back' : 'Create account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            if (!_isLogin) ...[TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Your name', border: OutlineInputBorder())), const SizedBox(height: 16)],
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: _loading ? null : _submit, child: _loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text(_isLogin ? 'Sign in' : 'Create account'))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 52, child: OutlinedButton.icon(onPressed: _loading ? null : _google, icon: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), label: const Text('Continue with Google'))),
            const SizedBox(height: 16),
            Center(child: TextButton(onPressed: () => setState(() => _isLogin = !_isLogin), child: Text(_isLogin ? "Don't have an account? Sign up" : 'Already have an account? Sign in'))),
          ]),
        ),
      ),
    );
  }
}
