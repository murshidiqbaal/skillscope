/// Resource model for learning materials related to skills
///
/// Represents learning resources (videos, courses, articles, PDFs) for each skill
class ResourceModel {
  final String id;
  final String skillId;
  final String title;
  final String url;
  final ResourceType type;
  final String description;

  const ResourceModel({
    required this.id,
    required this.skillId,
    required this.title,
    required this.url,
    required this.type,
    required this.description,
  });

  /// Create ResourceModel from JSON (Supabase response)
  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      type: ResourceType.fromString(json['type'] as String? ?? 'article'),
      description: json['description'] as String? ?? '',
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'skill_id': skillId,
    'title': title,
    'url': url,
    'type': type.toString(),
    'description': description,
  };

  /// Create a copy with modified fields
  ResourceModel copyWith({
    String? id,
    String? skillId,
    String? title,
    String? url,
    ResourceType? type,
    String? description,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          skillId == other.skillId &&
          title == other.title &&
          url == other.url &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      skillId.hashCode ^
      title.hashCode ^
      url.hashCode ^
      type.hashCode;

  @override
  String toString() =>
      'ResourceModel('
      'id: $id, '
      'skillId: $skillId, '
      'title: $title, '
      'type: $type)';
}

/// Enum for resource types with display names and icons
enum ResourceType {
  video('Video', 'https://img.icons8.com/color/96/000000/youtube.png'),
  course('Course', 'https://img.icons8.com/color/96/000000/graduation-cap.png'),
  article('Article', 'https://img.icons8.com/color/96/000000/document.png'),
  pdf('PDF', 'https://img.icons8.com/color/96/000000/pdf.png'),
  documentation(
    'Documentation',
    'https://img.icons8.com/color/96/000000/book.png',
  ),
  other('Resource', 'https://img.icons8.com/color/96/000000/link.png');

  final String displayName;
  final String iconUrl;

  const ResourceType(this.displayName, this.iconUrl);

  /// Parse resource type from string
  static ResourceType fromString(String value) {
    try {
      return ResourceType.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => ResourceType.other,
      );
    } catch (e) {
      return ResourceType.other;
    }
  }

  /// Get badge color for resource type
  int get badgeColor {
    switch (this) {
      case ResourceType.video:
        return 0xFFFF6B6B; // Red
      case ResourceType.course:
        return 0xFF4ECDC4; // Teal
      case ResourceType.article:
        return 0xFF45B7D1; // Blue
      case ResourceType.pdf:
        return 0xFFFFA500; // Orange
      case ResourceType.documentation:
        return 0xFF95E1D3; // Mint
      case ResourceType.other:
        return 0xFF95A5A6; // Gray
    }
  }

  /// Get abbreviation for badge
  String get abbreviation {
    switch (this) {
      case ResourceType.video:
        return 'VID';
      case ResourceType.course:
        return 'CRS';
      case ResourceType.article:
        return 'ART';
      case ResourceType.pdf:
        return 'PDF';
      case ResourceType.documentation:
        return 'DOC';
      case ResourceType.other:
        return 'RES';
    }
  }
}
