import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

@freezed
class SkillModel with _$SkillModel {
  const SkillModel._();

  const factory SkillModel({
    required String id,
    required String name,
    required String description,
    required String category,
    @JsonKey(name: 'demand_score') required int demandScore,
    @JsonKey(name: 'growth_rate') required int growthRate,
    @Default(false) bool isTrending,
    @Default('') String iconUrl,
  }) = _SkillModel;

  /// Computed demand level based on demand score
  String get demandLevel {
    if (demandScore >= 80) return 'High';
    if (demandScore >= 60) return 'Medium';
    if (demandScore >= 40) return 'Low';
    return 'Critical';
  }

  /// Computed formatted growth trend string
  String get growthTrend => '${growthRate > 0 ? '+' : ''}$growthRate%';

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);

  @override
  // TODO: implement category
  String get category => throw UnimplementedError();

  @override
  // TODO: implement demandScore
  int get demandScore => throw UnimplementedError();

  @override
  // TODO: implement description
  String get description => throw UnimplementedError();

  @override
  // TODO: implement growthRate
  int get growthRate => throw UnimplementedError();

  @override
  // TODO: implement iconUrl
  String get iconUrl => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isTrending
  bool get isTrending => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

// Manual fallback class to satisfy compiler while build_runner works
// This is a temporary measure as suggested by the user's Step 4 example.
/*
class SkillModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int demandScore;
  final int growthRate;
  final bool isTrending;

  SkillModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.demandScore,
    required this.growthRate,
    this.isTrending = false,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      demandScore: json['demand_score'] ?? 0,
      growthRate: json['growth_rate'] ?? 0,
      isTrending: json['isTrending'] ?? false,
    );
  }
}
*/
