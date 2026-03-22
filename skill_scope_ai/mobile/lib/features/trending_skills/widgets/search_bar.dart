import 'package:flutter/material.dart';

/// Premium Search Bar with Glassmorphism
///
/// Features:
/// - Glass effect background
/// - Animated focus border
/// - Gradient highlights
/// - Smooth focus transitions
class PremiumSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;

  const PremiumSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.placeholder = 'Search skills like Flutter, AI, DevOps...',
  }) : super(key: key);

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF4F46E5,
                ).withOpacity(0.1 * _focusController.value),
                blurRadius: 20 * _focusController.value,
                offset: Offset(0, 5 * _focusController.value),
              ),
              if (_isFocused)
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.1),
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
                colors: [
                  const Color(
                    0xFF1E293B,
                  ).withOpacity(0.5 + (0.3 * _focusController.value)),
                  const Color(
                    0xFF0F172A,
                  ).withOpacity(0.7 + (0.2 * _focusController.value)),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color.lerp(
                  const Color(0xFF06B6D4).withOpacity(0.2),
                  const Color(0xFF06B6D4).withOpacity(0.4),
                  _focusController.value,
                )!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color.lerp(
                      Colors.grey[600],
                      const Color(0xFF06B6D4),
                      _focusController.value,
                    ),
                    size: 20,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.controller.clear();
                            widget.onChanged('');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 14,
                ),
              ),
              cursorColor: const Color(0xFF4F46E5),
            ),
          ),
        );
      },
    );
  }
}
