import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/trending_skills/models/resource_model.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';
import 'package:mobile/features/trending_skills/repositories/skill_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:skill_scope_ai/features/trending_skills/models/skill_model.dart';
// import 'package:skill_scope_ai/features/trending_skills/models/resource_model.dart';
// import 'package:skill_scope_ai/features/trending_skills/repositories/skill_repository.dart';

/// Provider for SkillRepository instance
final skillRepositoryProvider = Provider<SkillRepository>((ref) {
  final supabaseClient = Supabase.instance.client;
  return SkillRepository(supabaseClient: supabaseClient);
});

/// Provider for fetching all trending skills
///
/// Auto-refreshes and handles caching internally
final skillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  final repository = ref.watch(skillRepositoryProvider);
  return repository.getTrendingSkills();
});

/// Provider for search query
final skillSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for selected category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Provider for filtered and searched skills
final filteredSkillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  final repository = ref.watch(skillRepositoryProvider);
  final searchQuery = ref.watch(skillSearchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  List<SkillModel> skills;

  // Apply category filter first
  if (selectedCategory != null && selectedCategory.isNotEmpty) {
    skills = await repository.getSkillsByCategory(category: selectedCategory);
  } else {
    skills = await repository.getTrendingSkills();
  }

  // Apply search filter
  if (searchQuery.isEmpty) {
    return skills;
  }

  final query = searchQuery.toLowerCase();
  return skills
      .where(
        (skill) =>
            skill.name.toLowerCase().contains(query) ||
            skill.description.toLowerCase().contains(query),
      )
      .toList();
});

/// Provider for pagination state
final skillsPaginationProvider = StateProvider<int>((ref) => 0);

/// Provider for pagination size
const int pageSize = 20;

/// Provider for paginated skills
final paginatedSkillsProvider = FutureProvider.family<List<SkillModel>, int>((
  ref,
  page,
) async {
  final repository = ref.watch(skillRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return repository.getPaginatedSkills(
    page: page,
    pageSize: pageSize,
    category: selectedCategory,
  );
});

/// Provider for skill detail by ID
final skillDetailProvider = FutureProvider.family<SkillModel?, String>((
  ref,
  skillId,
) async {
  final repository = ref.watch(skillRepositoryProvider);
  return repository.getSkillById(skillId);
});

/// Provider for resources of a specific skill
final skillResourcesProvider =
    FutureProvider.family<List<ResourceModel>, String>((ref, skillId) async {
      final repository = ref.watch(skillRepositoryProvider);
      return repository.getResourcesForSkill(skillId);
    });

/// Provider for resources by type
final skillResourcesByTypeProvider =
    FutureProvider.family<List<ResourceModel>, ({String skillId, String type})>(
      (ref, params) async {
        final repository = ref.watch(skillRepositoryProvider);
        return repository.getResourcesByType(
          skillId: params.skillId,
          type: params.type,
        );
      },
    );

/// Provider for total skill count
final skillCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(skillRepositoryProvider);
  return repository.getSkillCount();
});

/// Provider to refresh skills (force new fetch)
final refreshSkillsProvider = StateProvider<bool>((ref) => false);

/// Provider for refreshed trending skills
final refreshedSkillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  final repository = ref.watch(skillRepositoryProvider);
  ref.watch(refreshSkillsProvider); // Watch for refresh trigger
  return repository.getTrendingSkills(forceRefresh: true);
});

/// Notifier for managing favorite skills (future feature)
class FavoriteSkillsNotifier extends StateNotifier<List<String>> {
  FavoriteSkillsNotifier() : super([]);

  void toggleFavorite(String skillId) {
    if (state.contains(skillId)) {
      state = state.where((id) => id != skillId).toList();
    } else {
      state = [...state, skillId];
    }
  }

  bool isFavorite(String skillId) => state.contains(skillId);
}

/// Provider for favorite skills
final favoriteSkillsProvider =
    StateNotifierProvider<FavoriteSkillsNotifier, List<String>>((ref) {
      return FavoriteSkillsNotifier();
    });

/// Provider for top trending skills (demand score > 80)
final topTrendingSkillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  final allSkills = await ref.watch(skillsProvider.future);
  return allSkills.where((skill) => skill.isTrending).toList();
});

/// Provider for skill category list
final skillCategoriesProvider = Provider<List<String>>((ref) {
  return [
    'Mobile',
    'Web',
    'Backend',
    'AI',
    'DevOps',
    'Cloud Computing',
    'Data Science',
    'Security',
  ];
});

/// Notifier for managing skill learning progress (future feature)
class LearningProgressNotifier extends StateNotifier<Map<String, double>> {
  LearningProgressNotifier() : super({});

  void updateProgress(String skillId, double progress) {
    state = {...state, skillId: progress.clamp(0.0, 1.0)};
  }

  double getProgress(String skillId) => state[skillId] ?? 0.0;
}

/// Provider for learning progress
final learningProgressProvider =
    StateNotifierProvider<LearningProgressNotifier, Map<String, double>>((ref) {
      return LearningProgressNotifier();
    });
