import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_analysis_model.freezed.dart';
part 'resume_analysis_model.g.dart';

@freezed
class ResumeAnalysis with _$ResumeAnalysis {
  const factory ResumeAnalysis({
    required String jobRole,
    required int matchScore,
    @Default([]) List<String> detectedSkills,
    @Default([]) List<String> missingSkills,
    @Default([]) List<LearningResource> recommendedResources,
  }) = _ResumeAnalysis;

  factory ResumeAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ResumeAnalysisFromJson(json);

  @override
  // TODO: implement detectedSkills
  List<String> get detectedSkills => throw UnimplementedError();

  @override
  // TODO: implement jobRole
  String get jobRole => throw UnimplementedError();

  @override
  // TODO: implement matchScore
  int get matchScore => throw UnimplementedError();

  @override
  // TODO: implement missingSkills
  List<String> get missingSkills => throw UnimplementedError();

  @override
  // TODO: implement recommendedResources
  List<LearningResource> get recommendedResources => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

@freezed
class LearningResource with _$LearningResource {
  const factory LearningResource({
    required String title,
    required String url,
    String? description,
    String? platform,
  }) = _LearningResource;

  factory LearningResource.fromJson(Map<String, dynamic> json) =>
      _$LearningResourceFromJson(json);

  @override
  // TODO: implement description
  String? get description => throw UnimplementedError();

  @override
  // TODO: implement platform
  String? get platform => throw UnimplementedError();

  @override
  // TODO: implement title
  String get title => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement url
  String get url => throw UnimplementedError();
}

@freezed
class ResumeUploadRequest with _$ResumeUploadRequest {
  const factory ResumeUploadRequest({
    required String jobRole,
    required String resumeFilePath,
    required String fileType,
  }) = _ResumeUploadRequest;

  factory ResumeUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$ResumeUploadRequestFromJson(json);

  @override
  // TODO: implement fileType
  String get fileType => throw UnimplementedError();

  @override
  // TODO: implement jobRole
  String get jobRole => throw UnimplementedError();

  @override
  // TODO: implement resumeFilePath
  String get resumeFilePath => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

@freezed
class JobRoleSkills with _$JobRoleSkills {
  const factory JobRoleSkills({
    required String role,
    @Default([]) List<String> skills,
  }) = _JobRoleSkills;

  factory JobRoleSkills.fromJson(Map<String, dynamic> json) =>
      _$JobRoleSkillsFromJson(json);

  @override
  // TODO: implement role
  String get role => throw UnimplementedError();

  @override
  // TODO: implement skills
  List<String> get skills => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class ResumeValidationException implements Exception {
  final String message;
  final String? code;

  ResumeValidationException({required this.message, this.code});

  @override
  String toString() => message;
}
