import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/resume_analysis_model.dart';

/// Resume API Service for backend communication
class ResumeApiService {
  final Dio _dio;
  static const String baseUrl = 'http://localhost:8000';
  static const Duration timeoutDuration = Duration(seconds: 30);

  ResumeApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: timeoutDuration,
                receiveTimeout: timeoutDuration,
                sendTimeout: timeoutDuration,
              ),
            ) {
    _setupInterceptors();
  }

  /// Setup Dio interceptors for logging and error handling
  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  /// Analyze resume against a job role
  /// 
  /// Sends multipart request to backend with resume file
  /// Returns ResumeAnalysis with match score and recommendations
  Future<ResumeAnalysis> analyzeResume({
    required String jobRole,
    required String resumeFilePath,
    required String fileType, // 'pdf' or 'docx'
  }) async {
    try {
      // Validate inputs
      if (jobRole.trim().isEmpty) {
        throw ResumeValidationException(
          message: 'Job role cannot be empty',
          code: 'EMPTY_JOB_ROLE',
        );
      }

      if (resumeFilePath.isEmpty) {
        throw ResumeValidationException(
          message: 'Resume file not selected',
          code: 'NO_RESUME_FILE',
        );
      }

      // Create multipart form data
      final formData = FormData.fromMap({
        'job_role': jobRole.trim(),
        'resume': await MultipartFile.fromFile(
          resumeFilePath,
          filename: 'resume.$fileType',
        ),
      });

      // Send request to backend
      final response = await _dio.post<Map<String, dynamic>>(
        '/resume/validate',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      // Handle response
      if (response.statusCode == 200 && response.data != null) {
        // The backend returns {'analysis': {'raw_analysis': '...'}} or similar.
        // We need to parse the AI output. For now, I'll adjust the backend to return exactly what's needed.
        final analysisData = response.data!['analysis'];
        
        // Add job role to response data if missing
        if (analysisData is Map<String, dynamic>) {
            analysisData['jobRole'] = jobRole;
            return ResumeAnalysis.fromJson(analysisData);
        }
        
        throw ResumeValidationException(
          message: 'Invalid analysis data format',
          code: 'INVALID_DATA',
        );
      } else {
        throw ResumeValidationException(
          message: 'Unexpected response from server',
          code: 'INVALID_RESPONSE',
        );
      }
    } on ResumeValidationException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ResumeValidationException(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Get available job roles from backend
  /// 
  /// Returns list of job roles with their required skills
  Future<List<JobRoleSkills>> getJobRoles() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/job-roles',
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List<dynamic>)
            .map((item) => JobRoleSkills.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ResumeValidationException(
          message: 'Failed to fetch job roles',
          code: 'FETCH_JOB_ROLES_FAILED',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ResumeValidationException(
        message: 'Failed to fetch job roles: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Get recommended learning resources for missing skills
  /// 
  /// Returns list of learning resources for given skills
  Future<List<LearningResource>> getResourcesForSkills(
    List<String> skills,
  ) async {
    try {
      if (skills.isEmpty) {
        return [];
      }

      final response = await _dio.post<List<dynamic>>(
        '/learning-resources',
        data: {
          'skills': skills,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List<dynamic>)
            .map((item) =>
                LearningResource.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      debugPrint('Error fetching resources: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Error fetching resources: ${e.toString()}');
      return [];
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  ResumeValidationException _handleDioError(DioException error) {
    String message;
    String? code;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet.';
        code = 'CONNECTION_TIMEOUT';
        break;

      case DioExceptionType.sendTimeout:
        message = 'Request timeout. Server took too long to respond.';
        code = 'SEND_TIMEOUT';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Response timeout. Please try again.';
        code = 'RECEIVE_TIMEOUT';
        break;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final errorData = error.response?.data;

        if (statusCode == 400) {
          message = 'Invalid request. Please check your input.';
          code = 'BAD_REQUEST';
        } else if (statusCode == 413) {
          message = 'Resume file is too large. Max 10MB allowed.';
          code = 'FILE_TOO_LARGE';
        } else if (statusCode == 500) {
          message = 'Server error. Please try again later.';
          code = 'SERVER_ERROR';
        } else if (errorData is Map && errorData.containsKey('message')) {
          message = errorData['message'] as String;
        } else {
          message = 'Error analyzing resume. Status: $statusCode';
        }
        break;

      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        code = 'CANCELLED';
        break;

      case DioExceptionType.unknown:
        message = 'Network error. Please check your internet connection.';
        code = 'NETWORK_ERROR';
        break;

      default:
        message = 'An unexpected error occurred.';
        code = 'UNKNOWN';
    }

    return ResumeValidationException(
      message: message,
      code: code,
    );
  }

  /// Set authorization token for requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
