// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResumeAnalysis _$ResumeAnalysisFromJson(Map<String, dynamic> json) =>
    _ResumeAnalysis(
      jobRole: json['jobRole'] as String,
      matchScore: (json['matchScore'] as num).toInt(),
      detectedSkills:
          (json['detectedSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      missingSkills:
          (json['missingSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendedResources:
          (json['recommendedResources'] as List<dynamic>?)
              ?.map((e) => LearningResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ResumeAnalysisToJson(_ResumeAnalysis instance) =>
    <String, dynamic>{
      'jobRole': instance.jobRole,
      'matchScore': instance.matchScore,
      'detectedSkills': instance.detectedSkills,
      'missingSkills': instance.missingSkills,
      'recommendedResources': instance.recommendedResources,
    };

_LearningResource _$LearningResourceFromJson(Map<String, dynamic> json) =>
    _LearningResource(
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String?,
      platform: json['platform'] as String?,
    );

Map<String, dynamic> _$LearningResourceToJson(_LearningResource instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'description': instance.description,
      'platform': instance.platform,
    };

_ResumeUploadRequest _$ResumeUploadRequestFromJson(Map<String, dynamic> json) =>
    _ResumeUploadRequest(
      jobRole: json['jobRole'] as String,
      resumeFilePath: json['resumeFilePath'] as String,
      fileType: json['fileType'] as String,
    );

Map<String, dynamic> _$ResumeUploadRequestToJson(
  _ResumeUploadRequest instance,
) => <String, dynamic>{
  'jobRole': instance.jobRole,
  'resumeFilePath': instance.resumeFilePath,
  'fileType': instance.fileType,
};

_JobRoleSkills _$JobRoleSkillsFromJson(Map<String, dynamic> json) =>
    _JobRoleSkills(
      role: json['role'] as String,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$JobRoleSkillsToJson(_JobRoleSkills instance) =>
    <String, dynamic>{'role': instance.role, 'skills': instance.skills};
