import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF06B6D4).withOpacity(0.5),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0xFF1E293B),
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null
                                  ? const Icon(Icons.person_outline, size: 40, color: Colors.white54)
                                  : null,
                            ),
                          ),
                        ),
                        if (_imageFile == null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4F46E5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildGlassField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_rounded,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _bioController,
                      label: 'Professional Bio',
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _skillsController,
                      label: 'Skills (comma separated)',
                      icon: Icons.code_rounded,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _educationController,
                      label: 'Education',
                      icon: Icons.school_rounded,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _experienceController,
                      label: 'Experience',
                      icon: Icons.work_outline_rounded,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _projectsController,
                      label: 'Projects',
                      icon: Icons.assignment_rounded,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _githubController,
                      label: 'GitHub URL',
                      icon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _linkedinController,
                      label: 'LinkedIn URL',
                      icon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildGlassField(
                      controller: _portfolioController,
                      label: 'Portfolio URL',
                      icon: Icons.language_rounded,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Save Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).animate().slideY(begin: 0.5, curve: Curves.easeOutQuart),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.plusJakartaSans(color: Colors.white),
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.plusJakartaSans(color: Colors.white54),
          prefixIcon: Icon(icon, color: const Color(0xFF06B6D4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
