import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Suggestion Chip Widget
///
/// Features:
/// - Glassmorphism design
/// - Smooth hover effects
/// - Tap animation
/// - Gradient styling
class SuggestionChip extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Duration delay;

  const SuggestionChip({
    Key? key,
    required this.text,
    required this.onTap,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<SuggestionChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              _tapController.forward().then((_) {
                _tapController.reverse();
                widget.onTap();
              });
            },
            child: AnimatedBuilder(
              animation: _tapController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 - (_tapController.value * 0.05),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(
                        0xFF1E293B,
                      ).withOpacity(0.5 + (0.1 * (_isHovered ? 1 : 0))),
                      const Color(
                        0xFF0F172A,
                      ).withOpacity(0.7 + (0.1 * (_isHovered ? 1 : 0))),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFF06B6D4,
                    ).withOpacity(0.2 + (0.2 * (_isHovered ? 1 : 0))),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (_isHovered)
                      BoxShadow(
                        color: const Color(0xFF06B6D4).withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: const Color(
                        0xFF06B6D4,
                      ).withOpacity(0.7 + (0.3 * (_isHovered ? 1 : 0))),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: widget.delay)
        .slideY(
          begin: 0.2,
          duration: 400.ms,
          delay: widget.delay,
          curve: Curves.easeOut,
        );
  }
}
