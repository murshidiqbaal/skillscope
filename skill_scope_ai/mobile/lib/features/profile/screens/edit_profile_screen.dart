import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/profile_model.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _skillsController;
  late final TextEditingController _educationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _projectsController;
  late final TextEditingController _githubController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _portfolioController;

  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _bioController = TextEditingController(text: widget.profile.bio);
    _skillsController = TextEditingController(
      text: widget.profile.skills.join(', '),
    );
    _educationController = TextEditingController(
      text: widget.profile.education,
    );
    _experienceController = TextEditingController(
      text: widget.profile.experience,
    );
    _projectsController = TextEditingController(text: widget.profile.projects);
    _githubController = TextEditingController(text: widget.profile!.githubUrl);
    _linkedinController = TextEditingController(
      text: widget.profile.linkedinUrl,
    );
    _portfolioController = TextEditingController(
      text: widget.profile.portfolioUrl,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _projectsController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedSkills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text,
      bio: _bioController.text,
      skills: updatedSkills,
      education: _educationController.text,
      experience: _experienceController.text,
      projects: _projectsController.text,
      githubUrl: _githubController.text.isNotEmpty
          ? _githubController.text
          : null,
      linkedinUrl: _linkedinController.text.isNotEmpty
          ? _linkedinController.text
          : null,
      portfolioUrl: _portfolioController.text.isNotEmpty
          ? _portfolioController.text
          : null,
    );

    await ref
        .read(profileProvider.notifier)
        .updateProfile(profile: updatedProfile, newImageFile: _imageFile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.profile.profilePicture != null && widget.profile.profilePicture!.isNotEmpty
                                ? CachedNetworkImageProvider(widget.profile.profilePicture!) as ImageProvider
                                : null),
                        child: (_imageFile == null && (widget.profile.profilePicture == null || widget.profile.profilePicture!.isEmpty))
                            ? const Icon(Icons.add_a_photo, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 2,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a bio'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Skills (comma separated)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.settings),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _educationController,
                      decoration: const InputDecoration(
                        labelText: 'Education',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: 'Experience',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _projectsController,
                      decoration: const InputDecoration(
                        labelText: 'Projects',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _githubController,
                      decoration: const InputDecoration(
                        labelText: 'GitHub URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _linkedinController,
                      decoration: const InputDecoration(
                        labelText: 'LinkedIn URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _portfolioController,
                      decoration: const InputDecoration(
                        labelText: 'Portfolio URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.language),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _saveProfile,
                        child: const Text('Update Profile'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
