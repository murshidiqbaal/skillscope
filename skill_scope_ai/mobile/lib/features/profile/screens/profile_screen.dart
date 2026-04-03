import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/profile_provider.dart';
import '../utils/profile_pdf_generator.dart';
import 'create_profile_screen.dart';
import 'edit_profile_screen.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _DS {
  static const bg = Color(0xFF060D1A);
  static const surface = Color(0xFF0D1B2E);
  static const surfaceHigh = Color(0xFF112240);
  static const cyan = Color(0xFF00E5FF);
  static const cyanDim = Color(0xFF00B4CC);
  static const violet = Color(0xFF7C3AED);
  static const violetDim = Color(0xFF5B21B6);
  static const orange = Color(0xFFFF6B35);
  static const green = Color(0xFF10B981);
  static const textPrimary = Color(0xFFE2F0FF);
  static const textSecondary = Color(0xFF8BA3C7);
  static const textMuted = Color(0xFF4A6080);
  static const border = Color(0xFF1E3A5F);
}

// ─── Skill Market Demand Data ─────────────────────────────────────────────────
const _skillDemand = {
  'Flutter': 92,
  'Dart': 88,
  'React': 95,
  'Python': 97,
  'Kotlin': 84,
  'Swift': 80,
  'TypeScript': 93,
  'Rust': 76,
  'Go': 85,
  'AI/ML': 99,
  'Riverpod': 72,
  'Supabase': 78,
  'Firebase': 86,
  'Docker': 91,
  'GraphQL': 82,
};

int _getDemand(String skill) {
  final key = _skillDemand.keys.firstWhere(
    (k) => skill.toLowerCase().contains(k.toLowerCase()),
    orElse: () => '',
  );
  return key.isEmpty ? 65 + (skill.length * 3 % 30) : _skillDemand[key]!;
}

Color _demandColor(int demand) {
  if (demand >= 90) return _DS.orange;
  if (demand >= 75) return _DS.cyan;
  return _DS.green;
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const CreateProfileScreen();
        return Scaffold(
          backgroundColor: _DS.bg,
          body: Stack(
            children: [
              const _GridBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(context, ref, profile),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _HeroHeader(profile: profile),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _StatsRow(profile: profile)
                                  .animate()
                                  .fadeIn(delay: 200.ms, duration: 500.ms)
                                  .slideY(begin: 0.2),
                              const SizedBox(height: 20),
                              _SkillsCard(skills: profile.skills)
                                  .animate()
                                  .fadeIn(delay: 300.ms, duration: 500.ms)
                                  .slideY(begin: 0.2),
                              const SizedBox(height: 16),
                              if (profile.education != null &&
                                  profile.education!.isNotEmpty)
                                _InfoCard(
                                      title: 'Education',
                                      icon: Icons.school_outlined,
                                      content: profile.education!,
                                      accentColor: _DS.violet,
                                    )
                                    .animate()
                                    .fadeIn(delay: 400.ms, duration: 500.ms)
                                    .slideY(begin: 0.2),
                              if (profile.education != null &&
                                  profile.education!.isNotEmpty)
                                const SizedBox(height: 16),
                              if (profile.experience != null &&
                                  profile.experience!.isNotEmpty)
                                _InfoCard(
                                      title: 'Experience',
                                      icon: Icons.work_history_outlined,
                                      content: profile.experience!,
                                      accentColor: _DS.cyan,
                                    )
                                    .animate()
                                    .fadeIn(delay: 500.ms, duration: 500.ms)
                                    .slideY(begin: 0.2),
                              if (profile.experience != null &&
                                  profile.experience!.isNotEmpty)
                                const SizedBox(height: 16),
                              if (profile.projects != null &&
                                  profile.projects!.isNotEmpty)
                                _InfoCard(
                                      title: 'Projects',
                                      icon: Icons.rocket_launch_outlined,
                                      content: profile.projects!,
                                      accentColor: _DS.orange,
                                    )
                                    .animate()
                                    .fadeIn(delay: 600.ms, duration: 500.ms)
                                    .slideY(begin: 0.2),
                              const SizedBox(height: 16),
                              _LinksCard(profile: profile)
                                  .animate()
                                  .fadeIn(delay: 700.ms, duration: 500.ms)
                                  .slideY(begin: 0.2),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: _DS.bg,
        body: Center(child: CircularProgressIndicator(color: _DS.cyan)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: _DS.bg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load profile',
                style: GoogleFonts.spaceMono(
                  color: _DS.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              _CyberButton(
                label: 'Retry',
                onTap: () => ref.refresh(profileProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    dynamic profile,
  ) {
    return SliverAppBar(
      expandedHeight: 60,
      backgroundColor: _DS.bg.withOpacity(0.92),
      floating: true,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        title: Row(
          children: [
            _GlowDot(),
            const SizedBox(width: 10),
            Text(
              'SKILLSCOPE',
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _DS.cyan,
                letterSpacing: 3,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      actions: [
        _IconBtn(
          icon: Icons.download_outlined,
          color: _DS.cyan,
          onTap: () => ProfilePdfGenerator.generateAndDownload(profile),
        ),
        _IconBtn(
          icon: Icons.tune_rounded,
          color: _DS.textSecondary,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfileScreen(profile: profile),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─── Grid Background ──────────────────────────────────────────────────────────
class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D2040).withOpacity(0.5)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Radial glow at top
    final gradient = RadialGradient(
      center: const Alignment(0, -0.8),
      radius: 0.8,
      colors: [const Color(0xFF00E5FF).withOpacity(0.04), Colors.transparent],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Hero Header ──────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final dynamic profile;
  const _HeroHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _DS.cyan.withOpacity(0.06),
            _DS.violet.withOpacity(0.06),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: _DS.border, width: 1)),
      ),
      child: Column(
        children: [
          _AvatarWithRank(profile: profile)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.85, 0.85)),
          const SizedBox(height: 20),
          Text(
                profile.name ?? 'Anonymous',
                style: GoogleFonts.exo2(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _DS.textPrimary,
                  letterSpacing: 0.5,
                ),
              )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms)
              .slideY(begin: 0.15),
          const SizedBox(height: 6),
          _RankBadge(
            skills: profile.skills ?? [],
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 14),
          if (profile.bio != null && profile.bio!.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Text(
                profile.bio!,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: _DS.textSecondary,
                  height: 1.6,
                ),
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

// ─── Avatar with animated ring ────────────────────────────────────────────────
class _AvatarWithRank extends StatefulWidget {
  final dynamic profile;
  const _AvatarWithRank({required this.profile});

  @override
  State<_AvatarWithRank> createState() => _AvatarWithRankState();
}

class _AvatarWithRankState extends State<_AvatarWithRank>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _rotation = Tween(begin: 0.0, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotation,
            builder: (_, __) => Transform.rotate(
              angle: _rotation.value * 2 * 3.14159,
              child: CustomPaint(
                size: const Size(130, 130),
                painter: _RingPainter(),
              ),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _DS.surface, width: 4),
              boxShadow: [
                BoxShadow(
                  color: _DS.cyan.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 54,
              backgroundColor: _DS.surfaceHigh,
              backgroundImage:
                  (widget.profile.profilePicture != null &&
                      widget.profile.profilePicture!.isNotEmpty)
                  ? CachedNetworkImageProvider(widget.profile.profilePicture!)
                        as ImageProvider
                  : null,
              child:
                  (widget.profile.profilePicture == null ||
                      widget.profile.profilePicture!.isEmpty)
                  ? Text(
                      (widget.profile.name ?? 'S')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: GoogleFonts.exo2(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: _DS.cyan,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _DS.orange,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: _DS.orange.withOpacity(0.5), blurRadius: 8),
                ],
              ),
              child: Text(
                'PRO',
                style: GoogleFonts.spaceMono(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    final paint = Paint()
      ..shader = const SweepGradient(
        colors: [_DS.cyan, _DS.violet, Colors.transparent, _DS.cyan],
        stops: [0.0, 0.4, 0.6, 1.0],
      ).createShader(rect)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Rank Badge ───────────────────────────────────────────────────────────────
class _RankBadge extends StatelessWidget {
  final List<dynamic> skills;
  const _RankBadge({required this.skills});

  String get _rank {
    final count = skills.length;
    if (count >= 10) return '⚡ Expert Developer';
    if (count >= 6) return '🔥 Senior Developer';
    if (count >= 3) return '💡 Mid Developer';
    return '🌱 Junior Developer';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_DS.cyan.withOpacity(0.12), _DS.violet.withOpacity(0.12)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _DS.cyan.withOpacity(0.3), width: 1),
      ),
      child: Text(
        _rank,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: _DS.cyan,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final dynamic profile;
  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    final skills = (profile.skills as List?)?.length ?? 0;
    final avgDemand = skills == 0
        ? 0
        : (profile.skills as List)
                  .map((s) => _getDemand(s.toString()))
                  .reduce((a, b) => a + b) ~/
              skills;

    return Row(
      children: [
        _StatChip(value: '$skills', label: 'Skills', color: _DS.cyan),
        const SizedBox(width: 12),
        _StatChip(value: '$avgDemand%', label: 'Avg Demand', color: _DS.orange),
        const SizedBox(width: 12),
        _StatChip(
          value: '#${10 + skills * 3}',
          label: 'Rank',
          color: _DS.violet,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _DS.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.06), blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.exo2(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: _DS.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skills Card ──────────────────────────────────────────────────────────────
class _SkillsCard extends StatelessWidget {
  final List<dynamic> skills;
  const _SkillsCard({required this.skills});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Skills & Market Demand',
            icon: Icons.bar_chart_rounded,
            accentColor: _DS.cyan,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _DS.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _DS.orange.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up, size: 12, color: _DS.orange),
                  const SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      color: _DS.orange,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (skills.isEmpty)
            Center(
              child: Text(
                'No skills added yet',
                style: GoogleFonts.dmSans(color: _DS.textMuted),
              ),
            )
          else
            ...skills.asMap().entries.map((entry) {
              final i = entry.key;
              final skill = entry.value.toString();
              final demand = _getDemand(skill);
              return _SkillBar(skill: skill, demand: demand, delay: i * 60);
            }),
          const SizedBox(height: 4),
          Row(
            children: [
              _LegendDot(color: _DS.orange, label: 'Hot  90%+'),
              const SizedBox(width: 16),
              _LegendDot(color: _DS.cyan, label: 'High  75%+'),
              const SizedBox(width: 16),
              _LegendDot(color: _DS.green, label: 'Good'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 11, color: _DS.textMuted),
        ),
      ],
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String skill;
  final int demand;
  final int delay;
  const _SkillBar({
    required this.skill,
    required this.demand,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final color = _demandColor(demand);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color.withOpacity(0.25)),
                    ),
                    child: Text(
                      skill,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (demand >= 90) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: _DS.orange,
                    ),
                  ],
                ],
              ),
              Text(
                '$demand%',
                style: GoogleFonts.spaceMono(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: _DS.surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: demand / 100,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.6), color],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
                    ],
                  ),
                ),
              ).animate().scaleX(
                begin: 0,
                alignment: Alignment.centerLeft,
                delay: Duration(milliseconds: delay + 400),
                duration: 700.ms,
                curve: Curves.easeOutCubic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title, content;
  final IconData icon;
  final Color accentColor;
  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(title: title, icon: icon, accentColor: accentColor),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.12)),
            ),
            child: Text(
              content,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: _DS.textSecondary,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Links Card ───────────────────────────────────────────────────────────────
class _LinksCard extends StatelessWidget {
  final dynamic profile;
  const _LinksCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final links = <Map<String, dynamic>>[];
    if (profile.githubUrl != null && profile.githubUrl!.isNotEmpty)
      links.add({
        'label': 'GitHub',
        'url': profile.githubUrl,
        'icon': Icons.code_rounded,
        'color': _DS.textPrimary,
      });
    if (profile.linkedinUrl != null && profile.linkedinUrl!.isNotEmpty)
      links.add({
        'label': 'LinkedIn',
        'url': profile.linkedinUrl,
        'icon': Icons.people_outline_rounded,
        'color': _DS.cyan,
      });
    if (profile.portfolioUrl != null && profile.portfolioUrl!.isNotEmpty)
      links.add({
        'label': 'Portfolio',
        'url': profile.portfolioUrl,
        'icon': Icons.language_rounded,
        'color': _DS.violet,
      });

    if (links.isEmpty) return const SizedBox.shrink();

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Links',
            icon: Icons.link_rounded,
            accentColor: _DS.textSecondary,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: links
                .map(
                  (l) => _LinkPill(
                    label: l['label'],
                    icon: l['icon'],
                    color: l['color'],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinkPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _LinkPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.arrow_outward_rounded,
            size: 12,
            color: color.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Components ──────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _DS.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget? trailing;
  const _CardHeader({
    required this.title,
    required this.icon,
    required this.accentColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: accentColor),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.exo2(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _DS.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class _GlowDot extends StatefulWidget {
  @override
  State<_GlowDot> createState() => _GlowDotState();
}

class _GlowDotState extends State<_GlowDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: _DS.green.withOpacity(_anim.value),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _DS.green.withOpacity(_anim.value * 0.8),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _CyberButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CyberButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_DS.cyan, _DS.violet]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: _DS.cyan.withOpacity(0.3), blurRadius: 16),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
