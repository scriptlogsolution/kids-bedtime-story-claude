import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../models/child_profile_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../providers/child_provider.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({super.key});
  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _nameCtrl = TextEditingController();
  int _age = 5;
  String _language = 'English';
  final Set<String> _interests = {};
  bool _loading = false;
  static const _langs = ['English', 'Hindi', 'Gujarati', 'Marathi'];
  static const _interestOptions = ['Animals', 'Adventure', 'Fantasy', 'Moral', 'Space', 'Nature', 'Friendship', 'Magic'];

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter child's name"))); return; }
    setState(() => _loading = true);
    final uid = ref.read(authStateProvider).valueOrNull?.uid ?? '';
    final child = ChildProfileModel(id: const Uuid().v4(), parentId: uid, name: _nameCtrl.text.trim(), age: _age, language: _language, interests: _interests.toList());
    await ref.read(firestoreServiceProvider).saveChildProfile(child);
    ref.read(selectedChildProvider.notifier).state = child;
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add child profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Tell us about your child', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Child's name", border: OutlineInputBorder())),
          const SizedBox(height: 24),
          Text('Age: $_age years', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(value: _age.toDouble(), min: 2, max: 12, divisions: 10, label: '$_age', onChanged: (v) => setState(() => _age = v.toInt())),
          const SizedBox(height: 16),
          const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: _langs.map((l) => ChoiceChip(label: Text(l), selected: _language == l, onSelected: (_) => setState(() => _language = l))).toList()),
          const SizedBox(height: 24),
          const Text('Interests', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: _interestOptions.map((i) => FilterChip(label: Text(i), selected: _interests.contains(i), onSelected: (v) => setState(() => v ? _interests.add(i) : _interests.remove(i)))).toList()),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: _loading ? null : _save, child: _loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : const Text('Start reading stories'))),
        ]),
      ),
    );
  }
}
