import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';

/// Premium Animated Skills Chart
///
/// Features:
/// - Glassmorphism design
/// - Smooth chart animations
/// - Gradient bars with glow effects
/// - Interactive tooltips
/// - Dark mode optimized
class SkillsChart extends StatefulWidget {
  final List<SkillModel> skills;
  final int maxItems;

  const SkillsChart({Key? key, required this.skills, this.maxItems = 5})
    : super(key: key);

  @override
  State<SkillsChart> createState() => _SkillsChartState();
}

class _SkillsChartState extends State<SkillsChart> {
  late List<SkillModel> _topSkills;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _updateTopSkills();
  }

  @override
  void didUpdateWidget(SkillsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skills != widget.skills) {
      _updateTopSkills();
    }
  }

  void _updateTopSkills() {
    _topSkills = widget.skills.take(widget.maxItems).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_topSkills.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B).withOpacity(0.4),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
                  'Top Trending Skills',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                )
                .animate()
                .slideX(
                  begin: -0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 4),

            // Subtitle
            Text(
                  'Based on current market demand',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                )
                .animate()
                .slideX(
                  begin: -0.2,
                  end: 0,
                  delay: 100.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // Chart
            Expanded(
              child:
                  BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              // tooltipBgColor: Colors.grey[900]!,
                              tooltipBorderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              getTooltipItem:
                                  (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      '${_topSkills[groupIndex].name}\n${rod.toY.toInt()}/100',
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                            ),
                            handleBuiltInTouches: true,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= _topSkills.length) {
                                        return const SizedBox();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Text(
                                          _topSkills[index].name,
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                reservedSize: 50,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.right,
                                      );
                                    },
                                reservedSize: 40,
                                interval: 20,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _buildBarGroups(),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[800]!.withOpacity(0.5),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                        ),
                        swapAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                      )
                      .animate()
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 200.ms,
                        duration: 800.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 600.ms),
            ),
          ],
        ),
      ),
    );
  }

  /// Build bar groups
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(_topSkills.length, (index) {
      final skill = _topSkills[index];
      final color = _getBarColor(skill.demandScore);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: skill.demandScore.toDouble(),
            color: color,
            width: 24,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.grey[800]!.withOpacity(0.2),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
        ],
        showingTooltipIndicators: [0],
        // if (_touchedIndex == index) else [],
      );
    });
  }

  /// Get bar color
  Color _getBarColor(int score) {
    if (score >= 80) return Colors.green[400]!;
    if (score >= 60) return Colors.cyan[400]!;
    if (score >= 40) return Colors.blue[400]!;
    return Colors.indigo[400]!;
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.4),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 12),
            Text(
              'No data available',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
