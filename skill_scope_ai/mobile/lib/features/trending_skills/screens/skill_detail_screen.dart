import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/skill_model.dart';

class SkillDetailScreen extends StatelessWidget {
  final SkillModel skill;

  const SkillDetailScreen({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildResourcesList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4F46E5).withOpacity(0.4),
                    const Color(0xFF0F172A),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: Icon(
                _getCategoryIcon(skill.category),
                size: 80,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            skill.category,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
        const SizedBox(height: 12),
        Text(
          skill.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem("Demand Score", "${skill.demandScore}%", Icons.trending_up, Colors.blue),
        const SizedBox(width: 20),
        _buildStatItem("Growth Rate", "+${skill.growthRate}%", Icons.auto_graph, Colors.green),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this skill",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          skill.description ?? "No description available for this skill.",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: Colors.white.withOpacity(0.6),
            height: 1.6,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildResourcesList() {
    final resources = [
      {'title': 'Official Documentation', 'platform': 'System', 'url': 'https://google.com'},
      {'title': 'Complete Masterclass', 'platform': 'Udemy', 'url': 'https://udemy.com'},
      {'title': 'Crash Course for Beginners', 'platform': 'YouTube', 'url': 'https://youtube.com'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended Learning",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...resources.map((res) => _buildResourceCard(res)).toList(),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildResourceCard(Map<String, String> res) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.menu_book_outlined, color: Color(0xFF4F46E5), size: 18),
        ),
        title: Text(
          res['title']!,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          res['platform']!,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.open_in_new, color: Colors.white24, size: 16),
        onTap: () async {
          final uri = Uri.parse(res['url']!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mobile': return Icons.phone_android;
      case 'web': return Icons.language;
      case 'ai': return Icons.psychology;
      case 'backend': return Icons.storage;
      case 'devops': return Icons.cloud_done;
      default: return Icons.code;
    }
  }
}
