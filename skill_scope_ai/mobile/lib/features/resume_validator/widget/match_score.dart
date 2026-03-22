import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Match Score Widget
///
/// Features:
/// - Animated circular progress indicator
/// - Color gradient based on score
/// - Smooth number animation (0 → target score)
/// - Additional statistics display
/// - Professional typography
class MatchScoreWidget extends StatefulWidget {
  final double score;
  final Duration animationDuration;

  const MatchScoreWidget({
    Key? key,
    required this.score,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<MatchScoreWidget> createState() => _MatchScoreWidgetState();
}

class _MatchScoreWidgetState extends State<MatchScoreWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getScoreLabel(double score) {
    if (score >= 0.85) return "Excellent";
    if (score >= 0.70) return "Good";
    if (score >= 0.50) return "Fair";
    return "Needs Work";
  }

  Color _getScoreColor(double score) {
    if (score >= 0.85) return Colors.green[400]!;
    if (score >= 0.70) return Colors.cyan[400]!;
    if (score >= 0.50) return Colors.amber[400]!;
    return Colors.red[400]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Circular Progress Indicator
        SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    height: 240,
                    width: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[800]!.withOpacity(0.3),
                          Colors.grey[900]!.withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.grey[700]!.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),

                  // Animated progress circle
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(240, 240),
                        painter: CircleProgressPainter(
                          progress: _animation.value,
                          color: _getScoreColor(widget.score),
                        ),
                      );
                    },
                  ),

                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final displayScore = (_animation.value * 100).toInt();
                          return Text(
                            "$displayScore%",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              color: _getScoreColor(widget.score),
                              letterSpacing: -1,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getScoreLabel(widget.score),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[300],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .animate()
            .scale(
              begin: Offset(0, 0),
              end: Offset(1, 1),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 500.ms),

        const SizedBox(height: 32),

        // Statistics
        Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[900]!.withOpacity(0.5),
                    Colors.grey[950]!.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: Colors.grey[800]!.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    label: "Skills Match",
                    value: "78%",
                    icon: Icons.verified_rounded,
                    color: Colors.green[400]!,
                    delay: 200.ms,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey[800]!.withOpacity(0.3),
                  ),
                  _buildStatItem(
                    label: "Missing Skills",
                    value: "4",
                    icon: Icons.trending_up_rounded,
                    color: Colors.orange[400]!,
                    delay: 300.ms,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey[800]!.withOpacity(0.3),
                  ),
                  _buildStatItem(
                    label: "Relevance",
                    value: "85%",
                    icon: Icons.star_rounded,
                    color: Colors.amber[400]!,
                    delay: 400.ms,
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 0.2, duration: 600.ms),
      ],
    );
  }

  /// Build stat item
  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Duration delay,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20).animate().scale(
            begin: Offset(0, 0),
            end: Offset(1, 1),
            delay: delay,
            duration: 500.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ).animate().fadeIn(delay: delay, duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ).animate().fadeIn(delay: delay + 100.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

/// Custom painter for circular progress indicator
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..strokeWidth = 8
        ..color = Colors.grey[800]!.withOpacity(0.2)
        ..style = PaintingStyle.stroke,
    );

    // Progress arc with gradient
    final sweepAngle = (progress * 2 * 3.14159);
    final gradient = SweepGradient(
      colors: [color.withOpacity(0.5), color, color.withOpacity(0.7)],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      paint,
    );

    // Glow effect
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..strokeWidth = 2
        ..color = color.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
