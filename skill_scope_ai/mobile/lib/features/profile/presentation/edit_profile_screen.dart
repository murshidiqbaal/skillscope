import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:mobile/features/profile/presentation/provider/profile_provider.dart';

/// Screen for editing an existing user profile
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, this.profile});

  final Profile? profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _skillsController;
  late final TextEditingController _educationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _projectsController;

  late final FocusNode _nameFocus;
  late final FocusNode _bioFocus;
  late final FocusNode _skillsFocus;
  late final FocusNode _educationFocus;
  late final FocusNode _experienceFocus;
  late final FocusNode _projectsFocus;

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _skillsController = TextEditingController();
    _educationController = TextEditingController();
    _experienceController = TextEditingController();
    _projectsController = TextEditingController();

    _nameFocus = FocusNode();
    _bioFocus = FocusNode();
    _skillsFocus = FocusNode();
    _educationFocus = FocusNode();
    _experienceFocus = FocusNode();
    _projectsFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _projectsController.dispose();

    _nameFocus.dispose();
    _bioFocus.dispose();
    _skillsFocus.dispose();
    _educationFocus.dispose();
    _experienceFocus.dispose();
    _projectsFocus.dispose();
    super.dispose();
  }

  void _populateFields(Profile profile) {
    if (_initialized) return;

    _nameController.text = profile.name;
    _bioController.text = profile.bio ?? '';
    _skillsController.text = profile.skills.join(', ');
    _educationController.text = profile.education ?? '';
    _experienceController.text = profile.experience ?? '';
    _projectsController.text = profile.projects ?? '';

    _initialized = true;
  }

  Future<void> _submitUpdate() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      context.go('/login');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final formModel = ProfileFormModel(
        name: _nameController.text,
        bio: _bioController.text,
        skillsInput: _skillsController.text,
        education: _educationController.text,
        experience: _experienceController.text,
        projects: _projectsController.text,
      );

      final profile = formModel.toProfile(userId);

      await ref.read(updateProfileProvider.notifier).updateProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.go('/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), elevation: 0),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading profile: $err')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found to edit.'));
          }

          _populateFields(profile);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: 'Full Name *',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Name is required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        focusNode: _bioFocus,
                        label: 'Bio',
                        icon: Icons.description,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _skillsController,
                        focusNode: _skillsFocus,
                        label: 'Skills (comma separated)',
                        icon: Icons.star,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _educationController,
                        focusNode: _educationFocus,
                        label: 'Education',
                        icon: Icons.school,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _experienceController,
                        focusNode: _experienceFocus,
                        label: 'Experience',
                        icon: Icons.work,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _projectsController,
                        focusNode: _projectsFocus,
                        label: 'Projects',
                        icon: Icons.code,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: _isSubmitting ? null : _submitUpdate,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isSubmitting ? 'Updating...' : 'Update Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSubmitting)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
