import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/profile_provider.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _projectsController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();
  
  File? _imageFile;
  final _picker = ImagePicker();

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

    final skills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await ref.read(profileProvider.notifier).createProfile(
          name: _nameController.text,
          bio: _bioController.text,
          skills: skills,
          education: _educationController.text,
          experience: _experienceController.text,
          projects: _projectsController.text,
          githubUrl: _githubController.text.isNotEmpty ? _githubController.text : null,
          linkedinUrl: _linkedinController.text.isNotEmpty ? _linkedinController.text : null,
          portfolio_url: _portfolioController.text.isNotEmpty ? _portfolioController.text : null,
          imageFile: _imageFile,
        );

    if (mounted) {
      final finalState = ref.read(profileProvider);
      if (finalState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${finalState.error}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
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
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
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
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
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
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a bio' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Skills (comma separated)',
                        helperText: 'e.g. Flutter, Dart, Supabase',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.settings),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter at least one skill' : null,
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
                        child: const Text('Save Profile'),
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
