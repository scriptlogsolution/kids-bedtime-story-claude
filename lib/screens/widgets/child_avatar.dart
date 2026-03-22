import 'package:flutter/material.dart';
import '../../models/child_profile_model.dart';

class ChildAvatar extends StatelessWidget {
  final ChildProfileModel child;
  final bool isSelected;
  final VoidCallback onTap;
  const ChildAvatar({super.key, required this.child, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? cs.primary : Colors.transparent, width: 2.5)),
          child: CircleAvatar(radius: 26, backgroundColor: cs.primaryContainer, child: Text(child.name[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: cs.primary))),
        ),
        const SizedBox(height: 4),
        Text(child.name.split(' ').first, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.6))),
      ]),
    );
  }
}
