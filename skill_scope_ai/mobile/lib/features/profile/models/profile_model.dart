// Define a simple form model for building Profile from form inputs
class ProfileFormModel {
  final String name;
  final String bio;
  final String skillsInput; // Comma-separated string
  final String education;
  final String experience;
  final String projects;
  final String githubUrl;
  final String linkedinUrl;
  final String portfolioUrl;

  ProfileFormModel({
    required this.name,
    required this.bio,
    required this.skillsInput,
    required this.education,
    required this.experience,
    required this.projects,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.portfolioUrl,
  });

  /// Convert form input to Profile model
  /// Handles skills conversion from comma-separated string to array
  Profile toProfile(String userId) {
    // Convert comma-separated skills to array
    final skillsList = skillsInput
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    return Profile(
      id: '', // Will be set by repository
      userId: userId,
      name: name.trim(),
      bio: bio.trim(),
      education: education.trim(),
      experience: experience.trim(),
      skills: skillsList,
      projects: projects.trim(),
      email: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profilePicture: '',
      githubUrl: githubUrl.trim(),
      linkedinUrl: linkedinUrl.trim(),
      portfolioUrl: portfolioUrl.trim(),
    );
  }
}

/// Profile model representing user profile data
///
/// Maps to the 'profiles' table in Supabase with:
/// - JSONB fields: skills, education, experience, projects
/// - UUID fields: id (FK to auth.users), user_id (FK to auth.users)
/// - Text fields: name, bio, email
/// - Timestamp fields: created_at, updated_at
class Profile {
  final String id; // Primary key, FK to auth.users
  final String? userId; // Alternative user reference
  final String? name;
  final String? bio;
  final String? email;
  final List<String> skills; // JSONB array
  final String? education; // Can be JSONB array or text
  final String? experience; // Can be JSONB array or text
  final String? projects; // Can be JSONB array or text
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String profilePicture;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;

  Profile({
    required this.id,
    this.userId,
    this.name,
    this.bio,
    this.email,
    this.skills = const [],
    this.education,
    this.experience,
    this.projects,
    this.createdAt,
    this.updatedAt,
    required this.profilePicture,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
  });

  /// Create Profile from Supabase JSON response
  ///
  /// Handles JSONB array deserialization for skills
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String?,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      email: json['email'] as String?,
      skills: _parseSkillsArray(json['skills']),
      education: json['education'] as String?,
      experience: json['experience'] as String?,
      projects: json['projects'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      profilePicture: '',
    );
  }

  /// Convert Profile to JSON for Supabase insert/update
  ///
  /// Skills are serialized as a JSON array
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (email != null) 'email': email,
      'skills': skills, // Supabase will serialize this as JSONB array
      if (education != null) 'education': education,
      if (experience != null) 'experience': experience,
      if (projects != null) 'projects': projects,
    };
  }

  /// Create a copy with modified fields
  Profile copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    String? email,
    List<String>? skills,
    String? education,
    String? experience,
    String? projects,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePicture,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      projects: projects ?? this.projects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toString() => 'Profile(id: $id, name: $name, skills: $skills)';
}

/// Helper function to parse skills from various formats
///
/// Handles:
/// - JSON arrays: ["Flutter", "Dart"]
/// - Lists: [FlutterError details...] or just List<dynamic>
/// - Strings: "Flutter,Dart" (shouldn't happen but safe guard)
/// - Null/empty: returns empty list
List<String> _parseSkillsArray(dynamic skillsData) {
  if (skillsData == null) {
    return [];
  }

  // If it's already a List
  if (skillsData is List) {
    return skillsData
        .map((skill) {
          if (skill is String) return skill;
          if (skill is Map) return skill.toString();
          return skill.toString();
        })
        .where((skill) => skill.isNotEmpty)
        .toList();
  }

  // If it's a string (shouldn't be, but handle it)
  if (skillsData is String) {
    if (skillsData.isEmpty) return [];
    return skillsData
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();
  }

  // If it's a Map (shouldn't be, but handle it)
  if (skillsData is Map) {
    return [skillsData.toString()];
  }

  // Fallback
  return [];
}
