import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/skills_provider.dart';
import '../widgets/skill_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_filter.dart';
import '../widgets/skills_chart.dart';

class TrendingSkillsScreen extends ConsumerWidget {
  const TrendingSkillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(skillsProvider);
    final filteredSkills = ref.watch(skillsProvider.notifier).filteredSkills;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomSearchBar(),
                  const SizedBox(height: 20),
                  const CategoryFilter(),
                  const SizedBox(height: 24),
                  
                  // Top Skills Chart
                  if (state.searchQuery.isEmpty && state.selectedCategory == 'All')
                    const SkillsChart().animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                    
                  if (state.searchQuery.isEmpty && state.selectedCategory == 'All')
                    const SizedBox(height: 32),

                  Text(
                    state.selectedCategory == 'All' 
                      ? "Top Trending Skills" 
                      : "${state.selectedCategory} Skills",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          state.skills.when(
            data: (skills) {
              if (filteredSkills.isEmpty) {
                return _buildEmptyState();
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SkillCard(skill: filteredSkills[index]);
                    },
                    childCount: filteredSkills.length,
                  ),
                ),
              );
            },
            loading: () => _buildShimmerGrid(),
            error: (err, stack) => _buildErrorState(ref),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          "Trending Skills",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4F46E5).withOpacity(0.2),
                const Color(0xFF0F172A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
            ).animate(onPlay: (controller) => controller.repeat())
             .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.05));
          },
          childCount: 6,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(Icons.search_off_rounded, size: 64, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              "No skills found",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withOpacity(0.4),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              "Failed to load trends",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withOpacity(0.4),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(skillsProvider.notifier).fetchSkills(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
