import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Skill Chip Widget
///
/// Features:
/// - Animated selection state
/// - Glassmorphism design
/// - Color variations for missing/present skills
/// - Smooth hover effects
/// - Gradient backgrounds
class SkillChip extends StatefulWidget {
  final String label;
  final bool isMissing;
  final VoidCallback? onTap;

  const SkillChip({
    Key? key,
    required this.label,
    this.isMissing = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<SkillChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onHoverEnd() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_hoverController.value * 0.05),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isMissing
                    ? [
                        Colors.orange[600]!.withOpacity(
                          0.15 + (0.1 * _hoverController.value),
                        ),
                        Colors.orange[400]!.withOpacity(
                          0.08 + (0.05 * _hoverController.value),
                        ),
                      ]
                    : [
                        Colors.green[600]!.withOpacity(
                          0.15 + (0.1 * _hoverController.value),
                        ),
                        Colors.green[400]!.withOpacity(
                          0.08 + (0.05 * _hoverController.value),
                        ),
                      ],
              ),
              border: Border.all(
                color: widget.isMissing
                    ? Colors.orange[400]!.withOpacity(
                        0.3 + (0.2 * _hoverController.value),
                      )
                    : Colors.green[400]!.withOpacity(
                        0.3 + (0.2 * _hoverController.value),
                      ),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: widget.isMissing
                        ? Colors.orange[400]!.withOpacity(0.2)
                        : Colors.green[400]!.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isMissing
                      ? Icons.trending_up_rounded
                      : Icons.check_circle_rounded,
                  color: widget.isMissing
                      ? Colors.orange[400]
                      : Colors.green[400],
                  size: 14,
                ).animate().scaleXY(
                  begin: 0.6,
                  end: 1,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isMissing
                        ? Colors.orange[300]
                        : Colors.green[300],
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
