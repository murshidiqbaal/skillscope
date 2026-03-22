import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:mobile/features/profile/presentation/provider/profile_provider.dart';
import 'package:riverpod/src/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';


final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);

class ProfileNotifier extends AsyncNotifier<Profile?> {
  final _supabase = Supabase.instance.client;

  @override
  FutureOr<Profile?> build() async {
    final repository = ref.watch(profileRepositoryProvider);
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return repository.getProfileByUserId(user.id);
  }

  Future<void> createProfile({
    required String name,
    required String bio,
    required List<String> skills,
    required String education,
    required String experience,
    required String projects,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolio_url,
    File? imageFile,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final repository = ref.read(profileRepositoryProvider);
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await repository.uploadProfilePicture(user.id, imageFile);
      }

      final profile = Profile(
        id: const Uuid().v4(),
        userId: user.id,
        name: name,
        bio: bio,
        profilePicture: imageUrl,
        skills: skills,
        education: education,
        experience: experience,
        projects: projects,
        githubUrl: githubUrl,
        linkedinUrl: linkedinUrl,
        portfolioUrl: portfolio_url,
        createdAt: DateTime.now(),
      );

      await repository.createProfile(profile as Profile);
      return profile;
    });
  }

  Future<void> updateProfile({
    required Profile profile,
    File? newImageFile,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      Profile updatedProfile = profile;
      final repository = ref.read(profileRepositoryProvider);
      if (newImageFile != null) {
        final imageUrl = await repository.uploadProfilePicture(
          user.id,
          newImageFile,
        );
        updatedProfile = profile.copyWith(profilePicture: imageUrl);
      }

      await repository.updateProfile(updatedProfile as Profile);
      return updatedProfile;
    });
  }
}
