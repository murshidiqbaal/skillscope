import 'package:flutter/material.dart';

/// Animated three-dot typing indicator shown while AI is generating a response.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  static const _dotCount = 3;
  static const _dotSize = 7.0;
  static const _dotColor = Color(0xFF06B6D4);
  static const _staggerMs = 180;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _dotCount,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: -6,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    // Stagger the dot bounces
    for (var i = 0; i < _dotCount; i++) {
      Future.delayed(Duration(milliseconds: i * _staggerMs), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_dotCount, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0, _animations[i].value),
              child: Padding(
                padding: EdgeInsets.only(right: i < _dotCount - 1 ? 4 : 0),
                child: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: _dotColor.withOpacity(0.6 + (i * 0.15)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
