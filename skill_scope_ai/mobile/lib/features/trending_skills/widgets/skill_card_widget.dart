import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';

/// Premium Animated Skill Card
///
/// Features:
/// - Glassmorphism effect
/// - Gradient borders with glow
/// - Smooth hover/tap animations
/// - Trending badge with pulse animation
/// - Demand score visualization
/// - Growth indicator with animation
class SkillCard extends StatefulWidget {
  final SkillModel skill;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const SkillCard({
    Key? key,
    required this.skill,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  }) : super(key: key);

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
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
              scale: 1.0 + (_hoverController.value * 0.02),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF4F46E5,
                  ).withOpacity(0.1 + (_isHovered ? 0.2 : 0)),
                  blurRadius: _isHovered ? 40 : 20,
                  offset: const Offset(0, 10),
                ),
                if (_isHovered)
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Gradient border glow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(
                          0xFF4F46E5,
                        ).withOpacity(_isHovered ? 0.4 : 0.2),
                        const Color(
                          0xFF06B6D4,
                        ).withOpacity(_isHovered ? 0.4 : 0.1),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E293B).withOpacity(0.7),
                          const Color(0xFF0F172A).withOpacity(0.9),
                        ],
                      ),
                      backgroundBlendMode: BlendMode.multiply,
                    ),
                    child: _buildCardContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build card content
  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              _buildSkillIcon(),
              const SizedBox(width: 16),
              // Title and category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skill name
                    Text(
                      widget.skill.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4F46E5).withOpacity(0.2),
                            const Color(0xFF8B5CF6).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF06B6D4).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.skill.category,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Favorite button
              if (widget.onFavoriteTap != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onFavoriteTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.isFavorite
                            ? const Color(0xFF4F46E5).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: widget.isFavorite
                            ? const Color(0xFF06B6D4)
                            : Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Demand score
              _buildStatWidget(
                label: 'Demand',
                value: '${widget.skill.demandScore}',
                unit: '/100',
                color: _getDemandColor(widget.skill.demandScore),
              ),
              // Growth rate
              _buildGrowthWidget(),
            ],
          ),

          const SizedBox(height: 16),

          // Demand progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Market Demand',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.skill.demandLevel,
                    style: TextStyle(
                      color: _getDemandColor(widget.skill.demandScore),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar with gradient
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: widget.skill.demandScore / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getDemandColor(widget.skill.demandScore),
                              _getDemandColor(
                                widget.skill.demandScore,
                              ).withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Trending badge
          if (widget.skill.isTrending) ...[
            const SizedBox(height: 16),
            _buildTrendingBadge(),
          ],
        ],
      ),
    );
  }

  /// Build skill icon with gradient background
  Widget _buildSkillIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.2),
            const Color(0xFF06B6D4).withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.skill.iconUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: CachedNetworkImage(
                imageUrl: widget.skill.iconUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildIconPlaceholder(),
                errorWidget: (context, url, error) => _buildIconPlaceholder(),
              ),
            )
          : _buildIconPlaceholder(),
    );
  }

  /// Build icon placeholder
  Widget _buildIconPlaceholder() {
    return Center(
      child: Icon(Icons.code_rounded, color: Colors.grey[500], size: 28),
    );
  }

  /// Build stat widget
  Widget _buildStatWidget({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build growth widget with animated icon
  Widget _buildGrowthWidget() {
    final isPositive = widget.skill.growthRate > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Growth',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isPositive ? Colors.green[400] : Colors.red[400],
                  size: 18,
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scaleXY(
                  begin: 1,
                  end: 1.1,
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(width: 4),
            Text(
              widget.skill.growthTrend,
              style: TextStyle(
                color: isPositive ? Colors.green[400] : Colors.red[400],
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build trending badge with pulse animation
  Widget _buildTrendingBadge() {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange[400]!.withOpacity(0.3),
                Colors.orange[600]!.withOpacity(0.2),
              ],
            ),
            border: Border.all(
              color: Colors.orange[400]!.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Colors.orange[300],
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Trending',
                style: TextStyle(
                  color: Colors.orange[300],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scaleXY(
          begin: 0.95,
          end: 1.05,
          duration: 1500.ms,
          curve: Curves.easeInOut,
        );
  }

  /// Get demand color
  Color _getDemandColor(int score) {
    if (score >= 80) return Colors.green[400]!;
    if (score >= 60) return Colors.amber[400]!;
    if (score >= 40) return Colors.orange[400]!;
    return Colors.red[400]!;
  }
}
