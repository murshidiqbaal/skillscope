import 'package:mobile/features/trending_skills/models/resource_model.dart';
import 'package:mobile/features/trending_skills/models/skill_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'skill_model.dart';
// import 'resource_model.dart';

/// Repository for handling skill-related data operations
/// 
/// Responsibilities:
/// - Fetch trending skills from Supabase
/// - Filter skills by category
/// - Fetch resources for a skill
/// - Handle API errors
class SkillRepository {
  final SupabaseClient _supabaseClient;

  // Table names
  static const String _skillsTable = 'skills';
  static const String _resourcesTable = 'resources';

  // Cache
  List<SkillModel>? _skillsCache;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

  SkillRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Get all trending skills
  /// 
  /// Parameters:
  /// - forceRefresh: If true, ignores cache and fetches fresh data
  /// 
  /// Returns: List of skills sorted by demand score
  Future<List<SkillModel>> getTrendingSkills({
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first
      if (!forceRefresh && _skillsCache != null && _isValidCache()) {
        return _skillsCache!;
      }

      // Fetch from Supabase
      final response = await _supabaseClient
          .from(_skillsTable)
          .select()
          .order('demand_score', ascending: false);

      if (response is List) {
        final skills = (response as List)
            .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
            .toList();

        // Cache the results
        _skillsCache = skills;
        _cacheTime = DateTime.now();

        return skills;
      }

      return [];
    } catch (e) {
      print('Error fetching trending skills: $e');
      rethrow;
    }
  }

  /// Get skills filtered by category
  /// 
  /// Parameters:
  /// - category: The category to filter by
  /// - limit: Maximum number of skills to return (optional)
  /// 
  /// Returns: List of skills in the specified category
  Future<List<SkillModel>> getSkillsByCategory({
    required String category,
    int? limit,
  }) async {
    try {
      var query = _supabaseClient
          .from(_skillsTable)
          .select()
          .eq('category', category)
          .order('demand_score', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;

      if (response is List) {
        return (response as List)
            .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching skills by category: $e');
      rethrow;
    }
  }

  /// Search skills by name or description
  /// 
  /// Parameters:
  /// - query: Search query string
  /// 
  /// Returns: List of matching skills
  Future<List<SkillModel>> searchSkills(String query) async {
    try {
      if (query.isEmpty) {
        return getTrendingSkills();
      }

      final normalizedQuery = query.toLowerCase();

      // Get all skills and filter locally (Supabase FTS might be limited)
      final allSkills = await getTrendingSkills();
      return allSkills
          .where((skill) =>
              skill.name.toLowerCase().contains(normalizedQuery) ||
              skill.description.toLowerCase().contains(normalizedQuery))
          .toList();
    } catch (e) {
      print('Error searching skills: $e');
      rethrow;
    }
  }

  /// Get a single skill by ID
  /// 
  /// Parameters:
  /// - id: Skill ID
  /// 
  /// Returns: SkillModel or null if not found
  Future<SkillModel?> getSkillById(String id) async {
    try {
      final response = await _supabaseClient
          .from(_skillsTable)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return SkillModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching skill by ID: $e');
      rethrow;
    }
  }

  /// Get resources for a specific skill
  /// 
  /// Parameters:
  /// - skillId: The skill ID
  /// 
  /// Returns: List of resources for the skill
  Future<List<ResourceModel>> getResourcesForSkill(String skillId) async {
    try {
      final response = await _supabaseClient
          .from(_resourcesTable)
          .select()
          .eq('skill_id', skillId)
          .order('created_at', ascending: false);

      if (response is List) {
        return (response as List)
            .map((resource) =>
                ResourceModel.fromJson(resource as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching resources for skill: $e');
      rethrow;
    }
  }

  /// Get resources by type
  /// 
  /// Parameters:
  /// - skillId: The skill ID
  /// - type: Resource type to filter by
  /// 
  /// Returns: List of resources matching the type
  Future<List<ResourceModel>> getResourcesByType({
    required String skillId,
    required String type,
  }) async {
    try {
      final response = await _supabaseClient
          .from(_resourcesTable)
          .select()
          .eq('skill_id', skillId)
          .eq('type', type);

      if (response is List) {
        return (response as List)
            .map((resource) =>
                ResourceModel.fromJson(resource as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching resources by type: $e');
      rethrow;
    }
  }

  /// Get paginated skills
  /// 
  /// Parameters:
  /// - page: Page number (starts at 0)
  /// - pageSize: Number of items per page
  /// - category: Optional category filter
  /// 
  /// Returns: Paginated list of skills
  Future<List<SkillModel>> getPaginatedSkills({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    try {
      var query = _supabaseClient.from(_skillsTable).select();

      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      final offset = page * pageSize;
      final response = await query
          .order('demand_score', ascending: false)
          .range(offset, offset + pageSize - 1);

      if (response is List) {
        return (response as List)
            .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching paginated skills: $e');
      rethrow;
    }
  }

  /// Get skill count
  /// 
  /// Returns: Total number of skills
  Future<int> getSkillCount() async {
    try {
      final response = await _supabaseClient
          .from(_skillsTable)
          .select('id')
          .count(CountOption.exact);

      return response.count ?? 0;
    } catch (e) {
      print('Error getting skill count: $e');
      return 0;
    }
  }

  /// Clear the cache
  void clearCache() {
    _skillsCache = null;
    _cacheTime = null;
  }

  /// Check if cache is still valid
  bool _isValidCache() {
    if (_cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!).inMinutes < _cacheDuration.inMinutes;
  }

  /// Get cached skills if available
  List<SkillModel>? getCachedSkills() {
    if (_isValidCache()) {
      return _skillsCache;
    }
    return null;
  }
}