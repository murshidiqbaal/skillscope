import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/screens/create_profile_screen.dart';

import '../providers/profile_provider.dart';
import '../utils/profile_pdf_generator.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/skills_section.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const CreateProfileScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('SkillScope Resume'),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () =>
                    ProfilePdfGenerator.generateAndDownload(profile),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  // profile: profile,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(profile: profile),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SkillsSection(skills: profile.skills),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                EducationSection(
                  education: profile.education ?? 'Not specified',
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                ExperienceSection(
                  experience: profile.experience ?? 'Not specified',
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                // ProjectsSection(projects: profile.projects ?? 'Not specified'),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(profileProvider),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
