import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tappable suggestion chip shown on the empty state screen.
class SuggestionChip extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const SuggestionChip({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  State<SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<SuggestionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF4F46E5).withOpacity(0.15)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFF4F46E5).withOpacity(0.5)
                  : const Color(0xFF06B6D4).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon ?? Icons.lightbulb_outline_rounded,
                size: 14,
                color: const Color(0xFF06B6D4),
              ),
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
