import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/resume_validator_provider.dart';

/// Premium Job Role Input Widget
/// 
/// Features:
/// - Dark mode premium aesthetics
/// - Glassmorphism effects
/// - Smooth animations
/// - Interactive suggestions
class JobRoleInput extends ConsumerStatefulWidget {
  const JobRoleInput({Key? key}) : super(key: key);

  @override
  ConsumerState<JobRoleInput> createState() => _JobRoleInputState();
}

class _JobRoleInputState extends ConsumerState<JobRoleInput> {
  late TextEditingController _jobRoleController;
  bool _isFocused = false;

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
        // Label
        Text(
          'Target Job Role',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Input Field with Glassmorphism
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused
                    ? const Color(0xFF06B6D4)
                    : Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: TextField(
              controller: _jobRoleController,
              onChanged: (value) => ref.read(jobRoleProvider.notifier).state = value,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., Senior Flutter Developer',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.work_outline_rounded,
                  color: _isFocused
                      ? const Color(0xFF06B6D4)
                      : Colors.white.withOpacity(0.4),
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                errorText: validation.jobRoleError != null ? "" : null, // Dot indicator logic
              ),
            ),
          ),
        ),

        // Suggestions
        const SizedBox(height: 16),
        _buildSuggestions(context),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final suggestions = [
      'Frontend',
      'Backend',
      'Mobile',
      'UI/UX',
      'DevOps',
      'Data AI',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((role) {
        return GestureDetector(
          onTap: () {
            _jobRoleController.text = role;
            ref.read(jobRoleProvider.notifier).state = role;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              role,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.05)),
        );
      }).toList(),
    );
  }
}
