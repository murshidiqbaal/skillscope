import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';
import 'package:mobile/features/trending_skills/providers/skill_provider.dart';
import 'package:mobile/features/trending_skills/widgets/resource_card_widget.dart';
// import 'skill_model.dart';
// import 'resource_model.dart';
// import 'skills_provider.dart';
// import 'resource_card.dart';

/// Skill Detail Screen
///
/// Displays detailed information about a specific skill:
/// - Skill overview (name, description, demand, growth)
/// - Demand and growth visualizations
/// - Learning resources
/// - "Learn This Skill" button
class SkillDetailScreen extends ConsumerStatefulWidget {
  final String skillId;
  final SkillModel? initialSkill;

  const SkillDetailScreen({Key? key, required this.skillId, this.initialSkill})
    : super(key: key);

  @override
  ConsumerState<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends ConsumerState<SkillDetailScreen> {
  late ScrollController _scrollController;
  late GlobalKey _resourcesKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _resourcesKey = GlobalKey();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToResources() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Scrollable.ensureVisible(
        _resourcesKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final skillAsync = ref.watch(skillDetailProvider(widget.skillId));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isFavorite = ref
                  .watch(favoriteSkillsProvider)
                  .contains(widget.skillId);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  ref
                      .read(favoriteSkillsProvider.notifier)
                      .toggleFavorite(widget.skillId);
                },
              );
            },
          ),
        ],
      ),
      body: skillAsync.when(
        loading: () => _buildLoadingState(isMobile),
        error: (err, stack) => _buildErrorState(context),
        data: (skill) {
          if (skill == null) {
            return _buildErrorState(context);
          }

          return SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(context, skill, isMobile),
                ),

                // Stats cards
                SliverToBoxAdapter(
                  child: _buildStatsCards(context, skill, isMobile),
                ),

                // Description
                SliverToBoxAdapter(
                  child: _buildDescription(context, skill, isMobile),
                ),

                // Learn button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: 16,
                    ),
                    child: FilledButton.icon(
                      onPressed: _scrollToResources,
                      icon: const Icon(Icons.school),
                      label: const Text('Learn This Skill'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Resources section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: 8,
                    ),
                    child: Text(
                      'Learning Resources',
                      key: _resourcesKey,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: isMobile ? 12 : 16)),

                // Resources list
                Consumer(
                  builder: (context, ref, child) {
                    final resourcesAsync = ref.watch(
                      skillResourcesProvider(widget.skillId),
                    );

                    return resourcesAsync.when(
                      loading: () => SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 20,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: ResourceCardShimmer(),
                            ),
                            childCount: 3,
                          ),
                        ),
                      ),
                      error: (err, stack) => SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 20,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load resources',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      data: (resources) {
                        if (resources.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 20,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.library_books,
                                      size: 48,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No resources yet',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Check back soon for learning materials',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ResourceCard(resource: resources[index]),
                              ),
                              childCount: resources.length,
                            ),
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
          );
        },
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, SkillModel skill, bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill name
          Text(
            skill.name,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Category and badge
          Row(
            children: [
              Chip(
                label: Text(skill.category),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              if (skill.isTrending)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[400]!, Colors.orange[600]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Trending',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
  }

  /// Build stats cards
  Widget _buildStatsCards(
    BuildContext context,
    SkillModel skill,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Demand Score',
                  '${skill.demandScore}/100',
                  skill.demandLevel,
                  _getDemandColor(skill.demandScore),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Growth Rate',
                  skill.growthTrend,
                  skill.growthRate > 0 ? 'Rising' : 'Declining',
                  skill.growthRate > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Market Demand',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${skill.demandScore}%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getDemandColor(skill.demandScore),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: skill.demandScore / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getDemandColor(skill.demandScore),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  /// Build description section
  Widget _buildDescription(
    BuildContext context,
    SkillModel skill,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Skill',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            skill.description.isEmpty
                ? 'Learn one of the most in-demand skills in the job market today.'
                : skill.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Container(height: 100, color: Colors.grey[300])),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 100, color: Colors.grey[300])),
            ],
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Skill not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'The skill you\'re looking for doesn\'t exist',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Get color based on demand score
  Color _getDemandColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.amber;
    return Colors.red;
  }
}
