// profile_model.dart — add these new fields to your existing Profile class

// ── New fields to add to your Profile class ───────────────────────────────────
//
// final String? jobTitle;
// final String? location;
// final String? availability;          // 'Available' | 'Open to Opportunities' | 'Not Available'
// final String? workPreference;        // 'Remote' | 'Hybrid' | 'On-site'
// final String? yearsOfExperience;
// final String? targetRole;
// final String? salaryExpectation;
// final String? certifications;
// final String? spokenLanguages;
// final String? openSourceContributions;
// final String? achievements;
// final String? twitterUrl;
// final String? blogUrl;

// ── Example full model (adapt to your existing one) ───────────────────────────

class Profile {
  final String id;
  final String? profilePicture;
  final String name;
  final String? jobTitle;
  final String? bio;
  final String? location;
  final List<String> skills;

  // Career
  final String? availability;
  final String? workPreference;
  final String? yearsOfExperience;
  final String? targetRole;
  final String? salaryExpectation;

  // Skills & Certs
  final String? certifications;
  final String? spokenLanguages;

  // Background
  final String? education;
  final String? experience;
  final String? projects;
  final String? openSourceContributions;
  final String? achievements;

  // Links
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final String? twitterUrl;
  final String? blogUrl;

  const Profile({
    required this.id,
    this.profilePicture,
    required this.name,
    this.jobTitle,
    this.bio,
    this.location,
    this.skills = const [],
    this.availability,
    this.workPreference,
    this.yearsOfExperience,
    this.targetRole,
    this.salaryExpectation,
    this.certifications,
    this.spokenLanguages,
    this.education,
    this.experience,
    this.projects,
    this.openSourceContributions,
    this.achievements,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
    this.twitterUrl,
    this.blogUrl,
  });

  // ── fromJson ────────────────────────────────────────────────────────────────
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      profilePicture: json['profile_picture'] as String?,
      name: json['name'] as String? ?? '',
      jobTitle: json['job_title'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availability: json['availability'] as String?,
      workPreference: json['work_preference'] as String?,
      yearsOfExperience: json['years_of_experience'] as String?,
      targetRole: json['target_role'] as String?,
      salaryExpectation: json['salary_expectation'] as String?,
      certifications: json['certifications'] as String?,
      spokenLanguages: json['spoken_languages'] as String?,
      education: json['education'] as String?,
      experience: json['experience'] as String?,
      projects: json['projects'] as String?,
      openSourceContributions: json['open_source_contributions'] as String?,
      achievements: json['achievements'] as String?,
      githubUrl: json['github_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      portfolioUrl: json['portfolio_url'] as String?,
      twitterUrl: json['twitter_url'] as String?,
      blogUrl: json['blog_url'] as String?,
    );
  }

  // ── toJson ──────────────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id,
    'profile_picture': profilePicture,
    'name': name,
    'job_title': jobTitle,
    'bio': bio,
    'location': location,
    'skills': skills,
    'availability': availability,
    'work_preference': workPreference,
    'years_of_experience': yearsOfExperience,
    'target_role': targetRole,
    'salary_expectation': salaryExpectation,
    'certifications': certifications,
    'spoken_languages': spokenLanguages,
    'education': education,
    'experience': experience,
    'projects': projects,
    'open_source_contributions': openSourceContributions,
    'achievements': achievements,
    'github_url': githubUrl,
    'linkedin_url': linkedinUrl,
    'portfolio_url': portfolioUrl,
    'twitter_url': twitterUrl,
    'blog_url': blogUrl,
  };

  // ── copyWith ─────────────────────────────────────────────────────────────────
  Profile copyWith({
    String? id,
    String? profilePicture,
    String? name,
    String? jobTitle,
    String? bio,
    String? location,
    List<String>? skills,
    String? availability,
    String? workPreference,
    String? yearsOfExperience,
    String? targetRole,
    String? salaryExpectation,
    String? certifications,
    String? spokenLanguages,
    String? education,
    String? experience,
    String? projects,
    String? openSourceContributions,
    String? achievements,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioUrl,
    String? twitterUrl,
    String? blogUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      profilePicture: profilePicture ?? this.profilePicture,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      availability: availability ?? this.availability,
      workPreference: workPreference ?? this.workPreference,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      targetRole: targetRole ?? this.targetRole,
      salaryExpectation: salaryExpectation ?? this.salaryExpectation,
      certifications: certifications ?? this.certifications,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      projects: projects ?? this.projects,
      openSourceContributions:
          openSourceContributions ?? this.openSourceContributions,
      achievements: achievements ?? this.achievements,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      blogUrl: blogUrl ?? this.blogUrl,
    );
  }
}

// ── Supabase migration SQL ────────────────────────────────────────────────────
//
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS job_title TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS location TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS availability TEXT DEFAULT 'Open to Opportunities';
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS work_preference TEXT DEFAULT 'Remote';
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS years_of_experience TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS target_role TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS salary_expectation TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS certifications TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS spoken_languages TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS open_source_contributions TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS achievements TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS twitter_url TEXT;
// ALTER TABLE profiles ADD COLUMN IF NOT EXISTS blog_url TEXT;
