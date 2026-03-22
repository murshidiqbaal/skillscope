import 'dart:io';

import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'profile_model.dart';

/// Exception thrown when profile operations fail
class ProfileRepositoryException implements Exception {
  final String message;
  final String? code;

  ProfileRepositoryException({required this.message, this.code});

  @override
  String toString() => message;
}

/// Repository class for handling profile-related database operations
class ProfileRepository {
  final SupabaseClient client;

  const ProfileRepository({required this.client});

  /// Create a new profile for the authenticated user
  ///
  /// Throws [ProfileRepositoryException] if:
  /// - User is not authenticated
  /// - Database insertion fails
  /// - Network error occurs
  Future<Profile> createProfile(Profile profile) async {
    try {
      // Get current authenticated user
      final user = client.auth.currentUser;
      if (user == null) {
        throw ProfileRepositoryException(
          message: 'User is not authenticated.',
          code: 'UNAUTHENTICATED',
        );
      }

      // Insert with id = user.id (not a new UUID)
      final response = await client
          .from('profiles')
          .upsert({
            'id': user.id, // ← THIS MUST BE THE AUTH USER'S ID
            'user_id': user.id, // ← Can be same or omit if not needed
            'name': profile.name,
            'bio': profile.bio,
            'education': profile.education ?? [],
            'experience': profile.experience ?? [],
            'skills': profile.skills ?? [],
            'projects': profile.projects ?? [],
          })
          .select()
          .single();

      return Profile.fromJson(response);
    } on PostgrestException catch (e) {
      throw ProfileRepositoryException(
        message: 'Database error: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw ProfileRepositoryException(message: 'Failed to create profile: $e');
    }
  }

  /// Fetch user's existing profile
  ///
  /// Returns null if profile doesn't exist
  /// Throws [ProfileRepositoryException] on error
  Future<Profile?> getProfileByUserId(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Profile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ProfileRepositoryException(
        message: 'Failed to fetch profile: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw ProfileRepositoryException(
        message: 'Failed to fetch profile: ${e.toString()}',
      );
    }
  }

  /// Update existing profile
  ///
  /// Throws [ProfileRepositoryException] on error
  Future<Profile> updateProfile(Profile profile) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw ProfileRepositoryException(
          message: 'User is not authenticated.',
          code: 'UNAUTHENTICATED',
        );
      }

      final profileData = {
        'name': profile.name,
        'bio': profile.bio,
        'skills': profile.skills,
        'education': profile.education,
        'experience': profile.experience,
        'projects': profile.projects,
      };

      final response = await client
          .from('profiles')
          .update(profileData)
          .eq('user_id', userId)
          .select()
          .single();

      return Profile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ProfileRepositoryException(
        message: 'Database error: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw ProfileRepositoryException(
        message: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  /// Delete user's profile
  ///
  /// Throws [ProfileRepositoryException] on error
  Future<void> deleteProfile(String userId) async {
    try {
      await client.from('profiles').delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw ProfileRepositoryException(
        message: 'Database error: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw ProfileRepositoryException(
        message: 'Failed to delete profile: ${e.toString()}',
      );
    }
  }

  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName =
        '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final path = 'profile_pictures/$fileName';

    await client.storage
        .from('profiles')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

    final imageUrl = client.storage.from('profiles').getPublicUrl(path);
    return imageUrl;
  }
}
