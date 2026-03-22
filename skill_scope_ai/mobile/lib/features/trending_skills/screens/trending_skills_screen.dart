import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';
import 'package:mobile/features/trending_skills/providers/skill_provider.dart';
// import 'package:mobile/features/trending_skills/providers/skills_provider.dart';
import 'package:mobile/features/trending_skills/widgets/category_fileter.dart';
// import 'package:mobile/features/trending_skills/widgets/skills_chart.dart';
import 'package:mobile/features/trending_skills/widgets/search_bar.dart';
// import 'package:mobile/features/trending_skills/widgets/skill_card.dart';
import 'package:mobile/features/trending_skills/widgets/skill_card_widget.dart';
import 'package:mobile/features/trending_skills/widgets/skill_chart_widget.dart';
// import 'package:mobile/features/trending_skills/widgets/category_filter.dart';

/// Premium Animated Trending Skills Screen
///
/// A modern AI SaaS-style interface with:
/// - Animated gradient header
/// - Smooth chart animations
/// - Glass-like cards with gradients
/// - Staggered card animations
/// - Smooth interactions and transitions
/// - Dark mode premium design
class TrendingSkillsScreen extends ConsumerStatefulWidget {
  const TrendingSkillsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TrendingSkillsScreen> createState() =>
      _TrendingSkillsScreenState();
}

class _TrendingSkillsScreenState extends ConsumerState<TrendingSkillsScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late ScrollController _scrollController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(skillSearchQueryProvider.notifier).state = query;
  }

  void _onCategorySelected(String? category) {
    ref.read(selectedCategoryProvider.notifier).state = category;
    ref.read(skillsPaginationProvider.notifier).state = 0;
  }

  void _onRefresh() {
    ref.read(refreshSkillsProvider.notifier).state = !ref.read(
      refreshSkillsProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _onRefresh();
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Animated Header with Gradient
              SliverToBoxAdapter(
                child: _buildAnimatedHeader(context, isMobile),
              ),

              // Animated Chart Section
              SliverToBoxAdapter(child: _buildChartSection(context, isMobile)),

              SliverToBoxAdapter(child: SizedBox(height: isMobile ? 24 : 32)),

              // Modern Search Bar
              SliverToBoxAdapter(child: _buildSearchSection(isMobile)),

              SliverToBoxAdapter(child: SizedBox(height: isMobile ? 20 : 28)),

              // Animated Category Filters
              SliverToBoxAdapter(child: _buildCategoryFilters(isMobile)),

              SliverToBoxAdapter(child: SizedBox(height: isMobile ? 24 : 32)),

              // Animated Skills List
              Consumer(
                builder: (context, ref, child) {
                  final filteredSkillsAsync = ref.watch(filteredSkillsProvider);

                  return filteredSkillsAsync.when(
                    loading: () => _buildLoadingState(isMobile),
                    error: (err, stack) => _buildErrorState(context),
                    data: (skills) {
                      if (skills.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final skill = skills[index];
                            final isFavorite = ref
                                .watch(favoriteSkillsProvider)
                                .contains(skill.id);

                            return _buildAnimatedSkillCard(
                              context,
                              skill,
                              isFavorite,
                              index,
                            );
                          }, childCount: skills.length),
                        ),
                      );
                    },
                  );
                },
              ),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32 : 48)),
            ],
          ),
        ),
      ),
    );
  }

  /// Build animated header with gradient and blur effect
  Widget _buildAnimatedHeader(BuildContext context, bool isMobile) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4F46E5).withOpacity(0.1),
              const Color(0xFF8B5CF6).withOpacity(0.05),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF06B6D4).withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 20 : 28,
            isMobile ? 16 : 24,
            isMobile ? 20 : 28,
            isMobile ? 24 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              'Trending Skills',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
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
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                              'Discover the most in-demand skills in the tech industry',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey[400],
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
                      ],
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 16),
                  // Refresh button
                  Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4F46E5).withOpacity(0.2),
                              const Color(0xFF8B5CF6).withOpacity(0.2),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF06B6D4).withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _onRefresh,
                            tooltip: 'Refresh',
                          ),
                        ),
                      )
                      .animate()
                      .scale(
                        begin: Offset(0, 0),
                        end: Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build chart section with animation
  Widget _buildChartSection(BuildContext context, bool isMobile) {
    return Consumer(
      builder: (context, ref, child) {
        final skillsAsync = ref.watch(skillsProvider);

        return skillsAsync.when(
          loading: () => Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: _buildChartShimmer(isMobile),
          ),
          error: (err, stack) => const SizedBox.shrink(),
          data: (skills) {
            if (skills.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: SkillsChart(skills: skills)
                  .animate()
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 500.ms),
            );
          },
        );
      },
    );
  }

  /// Build search section
  Widget _buildSearchSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child:
          PremiumSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              )
              .animate()
              .slideY(
                begin: 0.2,
                end: 0,
                delay: 100.ms,
                duration: 600.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),
    );
  }

  /// Build category filters
  Widget _buildCategoryFilters(bool isMobile) {
    return Consumer(
      builder: (context, ref, child) {
        final categories = ref.watch(skillCategoriesProvider);
        final selectedCategory = ref.watch(selectedCategoryProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // All category
                PremiumFilterChip(
                      label: 'All',
                      selected: selectedCategory == null,
                      onSelected: (selected) {
                        _onCategorySelected(selected ? null : selectedCategory);
                      },
                      delay: 0.ms,
                    )
                    .animate()
                    .slideX(
                      begin: -0.3,
                      end: 0,
                      delay: 150.ms,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 500.ms),
                const SizedBox(width: 12),
                // Category chips
                ...List.generate(categories.length, (index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return Row(
                    children: [
                      PremiumFilterChip(
                            label: category,
                            selected: isSelected,
                            onSelected: (selected) {
                              _onCategorySelected(selected ? category : null);
                            },
                            delay: 50.ms,
                          )
                          .animate()
                          .slideX(
                            begin: -0.3,
                            end: 0,
                            delay: (150 + (index + 1) * 50).ms,
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(duration: 500.ms),
                      if (index < categories.length - 1)
                        const SizedBox(width: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build animated skill card
  Widget _buildAnimatedSkillCard(
    BuildContext context,
    SkillModel skill,
    bool isFavorite,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child:
          SkillCard(
                skill: skill,
                isFavorite: isFavorite,
                onTap: () {
                  context.push('/skill/${skill.id}', extra: skill);
                },
                onFavoriteTap: () {
                  ref
                      .read(favoriteSkillsProvider.notifier)
                      .toggleFavorite(skill.id);
                },
              )
              .animate()
              .slideY(
                begin: 0.3,
                end: 0,
                delay: Duration(milliseconds: 50 + (index * 50)),
                duration: 600.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),
    );
  }

  /// Build loading state with shimmer
  Widget _buildLoadingState(bool isMobile) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSkillCardShimmer(),
          ),
          childCount: 5,
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.2),
                      const Color(0xFF8B5CF6).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load skills',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please try again',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              _buildPremiumButton(label: 'Retry', onPressed: _onRefresh),
            ],
          ),
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.15),
                      const Color(0xFF06B6D4).withOpacity(0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Skills Found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Try adjusting your search or filters',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
              ),
              const SizedBox(height: 28),
              _buildPremiumButton(
                label: 'Explore Trending Skills',
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                  _onCategorySelected(null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build chart shimmer
  Widget _buildChartShimmer(bool isMobile) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
        ),
      ),
    );
  }

  /// Build skill card shimmer
  Widget _buildSkillCardShimmer() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.6),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  /// Build premium button
  Widget _buildPremiumButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF4F46E5), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
