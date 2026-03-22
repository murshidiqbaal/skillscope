import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for ProfileRepository instance
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final supabaseClient = Supabase.instance.client;
  return ProfileRepository(client: supabaseClient);
});

/// Provider to get current authenticated user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.id;
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider for current user's profile
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileByUserId(user.id);
});

/// Family provider to fetch user's profile by user ID
final userProfileProvider = FutureProvider.family<Profile?, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileByUserId(userId);
});

/// Notifier for handling profile creation
class CreateProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final ProfileRepository repository;
  final Ref ref;

  CreateProfileNotifier({required this.repository, required this.ref})
    : super(const AsyncValue.data(null));

  /// Create a new profile
  Future<void> createProfile(Profile profile) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.createProfile(profile);
      state = AsyncValue.data(result);
      // Invalidate currentProfileProvider to trigger redirect
      ref.invalidate(currentProfileProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// StateNotifier provider for profile creation
final createProfileProvider =
    StateNotifierProvider<CreateProfileNotifier, AsyncValue<Profile?>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return CreateProfileNotifier(repository: repository, ref: ref);
    });

/// Notifier for handling profile updates
class UpdateProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final ProfileRepository repository;
  final Ref ref;

  UpdateProfileNotifier({required this.repository, required this.ref})
    : super(const AsyncValue.data(null));

  /// Update an existing profile
  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.updateProfile(profile);
      state = AsyncValue.data(result);
      // Invalidate currentProfileProvider to keep state in sync
      ref.invalidate(currentProfileProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

/// StateNotifier provider for profile updates
final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<Profile?>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return UpdateProfileNotifier(repository: repository, ref: ref);
    });
