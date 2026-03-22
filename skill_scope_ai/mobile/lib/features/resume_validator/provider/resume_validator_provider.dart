import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/resume_analysis_model.dart';
import '../services/resume_api_services.dart';

/// Provider for Resume API Service
final resumeApiServiceProvider = Provider<ResumeApiService>((ref) {
  return ResumeApiService();
});

/// Provider for job role input
final jobRoleProvider = StateProvider<String>((ref) => '');

/// Provider for resume file path
final resumeFilePathProvider = StateProvider<String?>((ref) => null);

/// Provider for resume file type
final resumeFileTypeProvider = StateProvider<String?>((ref) => null);

/// State notifier for resume analysis
class ResumeAnalysisNotifier extends StateNotifier<AsyncValue<ResumeAnalysis?>> {
  final ResumeApiService apiService;

  ResumeAnalysisNotifier({required this.apiService})
      : super(const AsyncValue.data(null));

  /// Analyze resume against job role
  Future<void> analyzeResume({
    required String jobRole,
    required String resumeFilePath,
    required String fileType,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Validate inputs
      if (jobRole.trim().isEmpty) {
        throw ResumeValidationException(
          message: 'Please enter a job role',
          code: 'EMPTY_JOB_ROLE',
        );
      }

      if (resumeFilePath.isEmpty) {
        throw ResumeValidationException(
          message: 'Please select a resume file',
          code: 'NO_RESUME_FILE',
        );
      }

      // Call API
      final result = await apiService.analyzeResume(
        jobRole: jobRole,
        resumeFilePath: resumeFilePath,
        fileType: fileType,
      );

      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Reset analysis state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// State notifier provider for resume analysis
final resumeAnalysisProvider =
    StateNotifierProvider<ResumeAnalysisNotifier, AsyncValue<ResumeAnalysis?>>(
  (ref) {
    final apiService = ref.watch(resumeApiServiceProvider);
    return ResumeAnalysisNotifier(apiService: apiService);
  },
);

/// Provider for job roles list
final jobRolesProvider = FutureProvider<List<JobRoleSkills>>((ref) async {
  final apiService = ref.watch(resumeApiServiceProvider);
  return apiService.getJobRoles();
});

/// Provider for learning resources based on missing skills
final learningResourcesProvider =
    FutureProvider.family<List<LearningResource>, List<String>>(
  (ref, skills) async {
    final apiService = ref.watch(resumeApiServiceProvider);
    return apiService.getResourcesForSkills(skills);
  },
);
/// Provider for validation state
class ValidationState {
  final bool isJobRoleValid;
  final bool isResumeSelected;
  final String? jobRoleError;
  final String? resumeError;

  ValidationState({
    this.isJobRoleValid = true,
    this.isResumeSelected = false,
    this.jobRoleError,
    this.resumeError,
  });

  bool get isValid => isJobRoleValid && isResumeSelected;
}

/// Provider for form validation
final validationProvider = Provider<ValidationState>((ref) {
  final jobRole = ref.watch(jobRoleProvider);
  final resumeFile = ref.watch(resumeFilePathProvider);

  final isJobRoleValid = jobRole.trim().isNotEmpty;
  final isResumeSelected = resumeFile != null && resumeFile.isNotEmpty;

  return ValidationState(
    isJobRoleValid: isJobRoleValid,
    isResumeSelected: isResumeSelected,
    jobRoleError: !isJobRoleValid ? 'Please enter a job role' : null,
    resumeError: !isResumeSelected ? 'Please select a resume file' : null,
  );
});

/// Provider for analyze button enabled state
final isAnalyzeButtonEnabledProvider = Provider<bool>((ref) {
  final validation = ref.watch(validationProvider);
  final analysis = ref.watch(resumeAnalysisProvider);

  // Disable if loading or validation fails
  return !analysis.isLoading && validation.isValid;
});
