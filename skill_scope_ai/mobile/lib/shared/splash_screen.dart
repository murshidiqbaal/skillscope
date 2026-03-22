import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Vibrant Modern Animated Splash Screen
///
/// Features:
/// - Bold color scheme
/// - Morphing shapes
/// - Staggered animations
/// - Geometric patterns
/// - Playful energy
class VibrantSplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;
  final Duration animationDuration;

  const VibrantSplashScreen({
    Key? key,
    required this.onSplashComplete,
    this.animationDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<VibrantSplashScreen> createState() => _VibrantSplashScreenState();
}

class _VibrantSplashScreenState extends State<VibrantSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _shapeController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late List<AnimationController> _floatControllers;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _shapeController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _floatControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: Duration(seconds: 3 + index),
        vsync: this,
      )..repeat(),
    );
  }

  void _startAnimation() {
    _shapeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _textController.forward();
      }
    });
    _progressController.forward().then((_) {
      widget.onSplashComplete();
    });
  }

  @override
  void dispose() {
    _shapeController.dispose();
    _textController.dispose();
    _progressController.dispose();
    for (var controller in _floatControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[100]!],
          ),
        ),
        child: Stack(
          children: [
            // Background floating shapes
            _buildFloatingShapes(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo shape
                  _buildAnimatedShape(isMobile),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  // Animated text with reveal
                  _buildRevealText(),
                ],
              ),
            ),

            // Bottom progress with step indicators
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: _buildStepProgress(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build floating background shapes
  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        // Floating square 1
        Positioned(
          top: 80,
          left: 20,
          child: AnimatedBuilder(
            animation: _floatControllers[0],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  math.sin(_floatControllers[0].value * 2 * math.pi) * 20,
                ),
                child: child,
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // Floating circle 1
        Positioned(
          top: 150,
          right: 30,
          child: AnimatedBuilder(
            animation: _floatControllers[1],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.cos(_floatControllers[1].value * 2 * math.pi) * 15,
                  math.sin(_floatControllers[1].value * 2 * math.pi) * 15,
                ),
                child: child,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF06B6D4).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Floating triangle 1
        Positioned(
          bottom: 100,
          left: 40,
          child: AnimatedBuilder(
            animation: _floatControllers[2],
            builder: (context, child) {
              return Transform.rotate(
                angle: _floatControllers[2].value * 2 * math.pi,
                child: child,
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomPaint(
                  painter: TrianglePainter(
                    color: const Color(0xFFF59E0B).withOpacity(0.4),
                  ),
                  size: const Size(30, 30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build animated shape (morphing elements)
  Widget _buildAnimatedShape(bool isMobile) {
    final size = isMobile ? 140.0 : 180.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background glow
        AnimatedBuilder(
          animation: _shapeController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_shapeController.value * 0.2),
              child: Opacity(
                opacity: 1.0 - _shapeController.value * 0.3,
                child: Container(
                  width: size * 1.3,
                  height: size * 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C3AED).withOpacity(0.3),
                        const Color(0xFF7C3AED).withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Main animated logo
        AnimatedBuilder(
          animation: _shapeController,
          builder: (context, child) {
            return Transform.scale(
              scale: Tween<double>(begin: 0, end: 1).evaluate(
                CurvedAnimation(
                  parent: _shapeController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF7C3AED), const Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(size * 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.trending_up_rounded,
                    size: size * 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build reveal text animation
  Widget _buildRevealText() {
    return FadeTransition(
      opacity: _textController,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _textController, curve: Curves.easeOut),
            ),
        child: Column(
          children: [
            // Title with gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [const Color(0xFF7C3AED), const Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: Text(
                'SkillScope',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 52,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Elevate Your Professional Presence',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build step-based progress indicator
  Widget _buildStepProgress() {
    return Column(
      children: [
        // Step indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final progress = _progressController.value;
                  final stepProgress = (progress - (index * 0.25)) * 4;
                  final isActive = stepProgress.clamp(0.0, 1.0) > 0;

                  return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Color.lerp(
                              const Color(0xFF7C3AED),
                              const Color(0xFF06B6D4),
                              stepProgress.clamp(0.0, 1.0),
                            )
                          : Colors.grey[300],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Progress text
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            final percent = (_progressController.value * 100).toInt();
            return Text(
              '$percent%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF7C3AED),
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Custom triangle painter for geometric shapes
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    // Triangle path
    final trianglePath = Path();
    trianglePath.moveTo(size.width / 2, 0);
    trianglePath.lineTo(size.width, size.height);
    trianglePath.lineTo(0, size.height);
    trianglePath.close();

    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
