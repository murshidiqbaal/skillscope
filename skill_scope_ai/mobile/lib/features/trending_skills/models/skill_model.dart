/// Skill model representing job market skills
///
/// This model is immutable and uses equatable-like equality for proper state management.
class SkillModel {
  final String id;
  final String name;
  final String category;
  final int demandScore; // 0-100
  final int growthRate; // percentage
  final String description;
  final String iconUrl;

  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.demandScore,
    required this.growthRate,
    required this.description,
    required this.iconUrl,
  });

  /// Create SkillModel from JSON (Supabase response)
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      demandScore: json['demand_score'] as int? ?? 0,
      growthRate: json['growth_rate'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      iconUrl: json['icon_url'] as String? ?? '',
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'demand_score': demandScore,
    'growth_rate': growthRate,
    'description': description,
    'icon_url': iconUrl,
  };

  /// Create a copy with modified fields
  SkillModel copyWith({
    String? id,
    String? name,
    String? category,
    int? demandScore,
    int? growthRate,
    String? description,
    String? iconUrl,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      demandScore: demandScore ?? this.demandScore,
      growthRate: growthRate ?? this.growthRate,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  /// Check if skill is trending (demand score > 80)
  bool get isTrending => demandScore > 80;

  /// Get demand level as string
  String get demandLevel {
    if (demandScore >= 80) return 'Very High';
    if (demandScore >= 60) return 'High';
    if (demandScore >= 40) return 'Medium';
    return 'Low';
  }

  /// Get growth trend indicator
  String get growthTrend {
    if (growthRate > 0) return '+${growthRate}%';
    if (growthRate < 0) return '${growthRate}%';
    return 'Stable';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          demandScore == other.demandScore &&
          growthRate == other.growthRate;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      category.hashCode ^
      demandScore.hashCode ^
      growthRate.hashCode;

  @override
  String toString() =>
      'SkillModel('
      'id: $id, '
      'name: $name, '
      'category: $category, '
      'demandScore: $demandScore, '
      'growthRate: $growthRate)';
}

/// Category enum for easier filtering
enum SkillCategory {
  mobile('Mobile'),
  web('Web'),
  backend('Backend'),
  ai('AI'),
  devops('DevOps'),
  cloudComputing('Cloud Computing'),
  datascience('Data Science'),
  security('Security'),
  other('Other');

  final String displayName;
  const SkillCategory(this.displayName);

  /// Get category from string
  static SkillCategory fromString(String value) {
    try {
      return SkillCategory.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => SkillCategory.other,
      );
    } catch (e) {
      return SkillCategory.other;
    }
  }

  /// Convert to backend format
  String toBackendString() {
    switch (this) {
      case SkillCategory.mobile:
        return 'Mobile';
      case SkillCategory.web:
        return 'Web';
      case SkillCategory.backend:
        return 'Backend';
      case SkillCategory.ai:
        return 'AI';
      case SkillCategory.devops:
        return 'DevOps';
      case SkillCategory.cloudComputing:
        return 'Cloud Computing';
      case SkillCategory.datascience:
        return 'Data Science';
      case SkillCategory.security:
        return 'Security';
      case SkillCategory.other:
        return 'Other';
    }
  }
}
