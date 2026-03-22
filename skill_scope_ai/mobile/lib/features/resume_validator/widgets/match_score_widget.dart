import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Circular Match Score Widget
class MatchScoreWidget extends StatelessWidget {
  final double score;
  final String label;

  const MatchScoreWidget({
    Key? key,
    required this.score,
    this.label = 'Match Score',
  }) : super(key: key);

  Color _getScoreColor(double score) {
    if (score >= 0.8) return const Color(0xFF10B981); // Green
    if (score >= 0.6) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          Stack(
            alignment: Alignment.center,
            children: [
              // Background track
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 10,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              
              // Progress indicator
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  color: color,
                ).animate().custom(
                  duration: 1500.ms,
                  curve: Curves.easeOutQuart,
                  builder: (context, value, child) => CircularProgressIndicator(
                    value: value * (score / 100),
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    color: color,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              
              // Score text
              Column(
                children: [
                  Text(
                    '$score%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    score >= 80 ? 'Excellent' : score >= 60 ? 'Good' : 'Needs Work',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
