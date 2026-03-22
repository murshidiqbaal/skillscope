import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/resume_validator_provider.dart';

/// Premium Job Role Input Widget
/// 
/// Extracted from ResumeValidatorScreen for better modularity.
/// Features:
/// - Custom styling
/// - Job role suggestions
/// - Real-time validation integration
class JobRoleInput extends ConsumerStatefulWidget {
  const JobRoleInput({Key? key}) : super(key: key);

  @override
  ConsumerState<JobRoleInput> createState() => _JobRoleInputState();
}

class _JobRoleInputState extends ConsumerState<JobRoleInput> {
  late TextEditingController _jobRoleController;

  @override
  void initState() {
    super.initState();
    _jobRoleController = TextEditingController(
      text: ref.read(jobRoleProvider),
    );
  }

  @override
  void dispose() {
    _jobRoleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Target Job Role',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),

        // Input field
        TextField(
          controller: _jobRoleController,
          decoration: InputDecoration(
            hintText:
                'e.g., Flutter Developer, Backend Engineer, Data Scientist',
            prefixIcon: const Icon(Icons.work),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: validation.jobRoleError,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          onChanged: (value) {
            ref.read(jobRoleProvider.notifier).state = value;
          },
        ),

        // Suggestions
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _buildJobRoleSuggestions(context),
        ),
      ],
    );
  }

  /// Build job role suggestions
  Widget _buildJobRoleSuggestions(BuildContext context) {
    final suggestions = [
      'Flutter Developer',
      'Backend Engineer',
      'Data Scientist',
      'Frontend Developer',
      'DevOps Engineer',
      'Full Stack Developer',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular roles:',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            suggestions.length,
            (index) => ActionChip(
              onPressed: () {
                _jobRoleController.text = suggestions[index];
                ref.read(jobRoleProvider.notifier).state = suggestions[index];
              },
              label: Text(suggestions[index]),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
      ],
    );
  }
}
