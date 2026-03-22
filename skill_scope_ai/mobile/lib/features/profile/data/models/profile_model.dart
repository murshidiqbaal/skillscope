/// Profile model representing a user's profile in the database
class Profile {
  final String? id;
  final String userId;
  final String name;
  final String? bio;
  final List<String> skills;
  final String? education;
  final String? experience;
  final String? projects;
  final String? profilePicture;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final DateTime? createdAt;
  final String? email;

  final dynamic updatedAt;

  const Profile({
    this.email,
    this.id,
    required this.userId,
    required this.name,
    this.bio,
    this.skills = const [],
    this.education,
    this.experience,
    this.projects,
    this.profilePicture,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String?,
    userId: json['user_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    bio: json['bio'] as String?,
    skills:
        (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [],
    education: json['education'] as String?,
    experience: json['experience'] as String?,
    projects: json['projects'] as String?,
    profilePicture: json['profile_picture'] as String?,
    githubUrl: json['github_url'] as String?,
    linkedinUrl: json['linkedin_url'] as String?,
    portfolioUrl: json['portfolio_url'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'] as String)
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'] as String)
        : null,
    email: json['email'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'name': name,
    'bio': bio,
    'skills': skills,
    'education': education,
    'experience': experience,
    'projects': projects,
    'profile_picture': profilePicture,
    'github_url': githubUrl,
    'linkedin_url': linkedinUrl,
    'portfolio_url': portfolioUrl,
    'created_at': createdAt?.toIso8601String(),
    'email': email,
  };

  Profile copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    List<String>? skills,
    String? education,
    String? experience,
    String? projects,
    String? profilePicture,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioUrl,
    DateTime? createdAt,
    String? email,
  }) => Profile(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    bio: bio ?? this.bio,
    skills: skills ?? this.skills,
    education: education ?? this.education,
    experience: experience ?? this.experience,
    projects: projects ?? this.projects,
    profilePicture: profilePicture ?? this.profilePicture,
    githubUrl: githubUrl ?? this.githubUrl,
    linkedinUrl: linkedinUrl ?? this.linkedinUrl,
    portfolioUrl: portfolioUrl ?? this.portfolioUrl,
    createdAt: createdAt ?? this.createdAt,
    email: email ?? this.email,
  );
}

/// Form validation model for CreateProfileScreen
class ProfileFormModel {
  final String name;
  final String bio;
  final String skillsInput;
  final String education;
  final String experience;
  final String projects;

  ProfileFormModel({
    required this.name,
    required this.bio,
    required this.skillsInput,
    required this.education,
    required this.experience,
    required this.projects,
  });

  Profile toProfile(String userId) {
    final skillsList = skillsInput
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return Profile(
      userId: userId,
      name: name.trim(),
      bio: bio.trim().isEmpty ? null : bio.trim(),
      skills: skillsList,
      education: education.trim().isEmpty ? null : education.trim(),
      experience: experience.trim().isEmpty ? null : experience.trim(),
      projects: projects.trim().isEmpty ? null : projects.trim(),
    );
  }

  bool isValid() => name.trim().isNotEmpty;

  String? getValidationError() {
    if (name.trim().isEmpty) return 'Name is required';
    if (name.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }
}
