import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Premium Animated Filter Chip
/// 
/// Features:
/// - Gradient background when selected
/// - Smooth selection animation
/// - Glass effect borders
/// - Hover animation
class PremiumFilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Duration delay;

  const PremiumFilterChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<PremiumFilterChip> createState() => _PremiumFilterChipState();
}

class _PremiumFilterChipState extends State<PremiumFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _selectController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _selectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (widget.selected) {
      _selectController.forward();
    }
  }

  @override
  void didUpdateWidget(PremiumFilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _selectController.forward();
      } else {
        _selectController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onSelected(!widget.selected),
        child: AnimatedBuilder(
          animation: _selectController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_selectController.value * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    if (widget.selected || _isHovered)
                      BoxShadow(
                        color: const Color(0xFF4F46E5)
                            .withOpacity(0.2 * _selectController.value),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.selected
                          ? [
                              const Color(0xFF4F46E5)
                                  .withOpacity(0.6 + (0.2 * _selectController.value)),
                              const Color(0xFF8B5CF6)
                                  .withOpacity(0.5 + (0.2 * _selectController.value)),
                            ]
                          : [
                              Colors.grey[900]!
                                  .withOpacity(0.4 + (0.1 * (_isHovered ? 1 : 0))),
                              Colors.grey[900]!
                                  .withOpacity(0.3 + (0.1 * (_isHovered ? 1 : 0))),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.selected
                          ? const Color(0xFF06B6D4)
                              .withOpacity(0.5 + (0.3 * _selectController.value))
                          : const Color(0xFF06B6D4).withOpacity(
                              0.2 + (0.1 * (_isHovered ? 1 : 0))),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      if (widget.selected)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                              .animate()
                              .scale(
                                begin: Offset(0, 0),
                                end: Offset(1, 1),
                                duration: 300.ms,
                                curve: Curves.easeOut,
                              ),
                        ),
                      // Label
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.selected ? Colors.white : Colors.grey[300],
                          fontWeight: widget.selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}