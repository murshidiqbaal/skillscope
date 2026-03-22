import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) => Chip(
            label: Text(skill),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          )).toList(),
        ),
      ],
    );
  }
}
