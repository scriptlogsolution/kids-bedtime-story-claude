import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          CircleAvatar(radius: 36, backgroundColor: cs.primaryContainer, child: Text((user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : 'U'), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: cs.primary))),
          const SizedBox(height: 12),
          Text(user?.displayName ?? 'Parent', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(user?.email ?? '', style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: cs.secondary.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('Free plan', style: TextStyle(color: cs.secondary, fontWeight: FontWeight.w600, fontSize: 12))),
          const SizedBox(height: 32),
          _Tile(icon: Icons.star_outline, label: 'Upgrade to Premium', onTap: () {}),
          _Tile(icon: Icons.child_care_outlined, label: 'Manage child profiles', onTap: () => context.push('/add-child')),
          _Tile(icon: Icons.help_outline, label: 'Help & support', onTap: () {}),
          const SizedBox(height: 16),
          _Tile(icon: Icons.logout, label: 'Sign out', color: cs.error, onTap: () async { await ref.read(authServiceProvider).signOut(); if (context.mounted) context.go('/auth'); }),
        ]),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Color? color;
  const _Tile({required this.icon, required this.label, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return ListTile(leading: Icon(icon, color: c, size: 22), title: Text(label, style: TextStyle(color: c, fontSize: 15)), trailing: Icon(Icons.arrow_forward_ios, size: 14, color: c.withOpacity(0.4)), onTap: onTap, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }
}
