import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for handling profile data operations with Supabase
///
/// Handles:
/// - Creating new profiles
/// - Fetching profiles by user ID
/// - Updating existing profiles
/// - Proper JSONB array serialization/deserialization
class ProfileRepository {
  final SupabaseClient client;

  ProfileRepository({required this.client});

  /// Create a new profile
  ///
  /// Important: The profile.id MUST match an authenticated user's ID
  /// due to the foreign key constraint on auth.users
  Future<Profile> createProfile(Profile profile) async {
    try {
      // Get current authenticated user
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('UNAUTHENTICATED: User not logged in');
      }

      // Profile data with proper JSONB handling
      final profileData = {
        'id': user.id, // ← CRITICAL: Must be auth user's ID
        'user_id': user.id,
        'name': profile.name,
        'bio': profile.bio,
        'education': profile.education,
        'experience': profile.experience,
        'skills': profile.skills, // Array will be properly serialized
        'projects': profile.projects,
        'email': profile.email ?? user.email,
      };

      // Upsert and return created/updated profile.
      // Uses upsert so that if the profile already exists, it is updated instead of failing.
      final response = await client
          .from('profiles')
          .upsert(profileData)
          .select()
          .single();

      return Profile.fromJson(response);
    } catch (e) {
      print('Create Profile Error: $e');
      rethrow;
    }
  }

  /// Fetch profile by user ID
  ///
  /// Returns null if no profile exists for the user
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

      return Profile.fromJson(response);
    } catch (e) {
      print('Get Profile Error: $e');
      rethrow;
    }
  }

  /// Fetch profile by ID (auth user ID)
  ///
  /// Alternative to getProfileByUserId using the primary key
  Future<Profile?> getProfileById(String id) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Profile.fromJson(response);
    } catch (e) {
      print('Get Profile By ID Error: $e');
      rethrow;
    }
  }

  /// Update an existing profile
  ///
  /// Handles JSONB arrays properly
  Future<Profile> updateProfile(Profile profile) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('UNAUTHENTICATED: User not logged in');
      }

      // Ensure we're updating the right profile
      if (profile.id != user.id) {
        throw Exception('UNAUTHORIZED: Cannot update other users profiles');
      }

      final profileData = {
        'name': profile.name,
        'bio': profile.bio,
        'education': profile.education,
        'experience': profile.experience,
        'skills': profile.skills, // Array serialization
        'projects': profile.projects,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await client
          .from('profiles')
          .update(profileData)
          .eq('id', user.id)
          .select()
          .single();

      return Profile.fromJson(response);
    } catch (e) {
      print('Update Profile Error: $e');
      rethrow;
    }
  }

  /// Delete a profile
  ///
  /// Can only delete own profile
  Future<void> deleteProfile(String profileId) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('UNAUTHENTICATED: User not logged in');
      }

      if (profileId != user.id) {
        throw Exception('UNAUTHORIZED: Cannot delete other users profiles');
      }

      await client.from('profiles').delete().eq('id', profileId);
    } catch (e) {
      print('Delete Profile Error: $e');
      rethrow;
    }
  }

  /// Stream real-time profile updates
  ///
  /// Useful for real-time UI updates
  Stream<Profile?> streamProfile(String userId) {
    return client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((list) {
          if (list.isEmpty) return null;
          return Profile.fromJson(list.first);
        });
  }
}
