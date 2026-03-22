// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mobile/features/profile/data/models/profile_model.dart';
// import 'package:mobile/features/profile/presentation/provider/profile_provider.dart';

// /// Screen for creating a new user profile
// ///
// /// This screen provides a form for users to enter their profile information
// /// and saves it to the Supabase 'profiles' table.
// ///
// /// Features:
// /// - Form validation
// /// - Loading states
// /// - Error handling with snackbars
// /// - Automatic user ID retrieval
// /// - Skills conversion from comma-separated to array
// /// - Navigation to profile screen on success
// class CreateProfileScreen extends ConsumerStatefulWidget {
//   const CreateProfileScreen({super.key});

//   @override
//   ConsumerState<CreateProfileScreen> createState() =>
//       _CreateProfileScreenState();
// }

// class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _bioController;
//   late final TextEditingController _skillsController;
//   late final TextEditingController _educationController;
//   late final TextEditingController _experienceController;
//   late final TextEditingController _projectsController;

//   late final FocusNode _nameFocus;
//   late final FocusNode _bioFocus;
//   late final FocusNode _skillsFocus;
//   late final FocusNode _educationFocus;
//   late final FocusNode _experienceFocus;
//   late final FocusNode _projectsFocus;

//   final _formKey = GlobalKey<FormState>();
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   void _initializeControllers() {
//     _nameController = TextEditingController();
//     _bioController = TextEditingController();
//     _skillsController = TextEditingController();
//     _educationController = TextEditingController();
//     _experienceController = TextEditingController();
//     _projectsController = TextEditingController();

//     _nameFocus = FocusNode();
//     _bioFocus = FocusNode();
//     _skillsFocus = FocusNode();
//     _educationFocus = FocusNode();
//     _experienceFocus = FocusNode();
//     _projectsFocus = FocusNode();
//   }

//   @override
//   void dispose() {
//     _disposeControllers();
//     _disposeFocusNodes();
//     super.dispose();
//   }

//   void _disposeControllers() {
//     _nameController.dispose();
//     _bioController.dispose();
//     _skillsController.dispose();
//     _educationController.dispose();
//     _experienceController.dispose();
//     _projectsController.dispose();
//   }

//   void _disposeFocusNodes() {
//     _nameFocus.dispose();
//     _bioFocus.dispose();
//     _skillsFocus.dispose();
//     _educationFocus.dispose();
//     _experienceFocus.dispose();
//     _projectsFocus.dispose();
//   }

//   /// Validate form and submit profile
//   Future<void> _submitProfile() async {
//     // Unfocus keyboard
//     FocusManager.instance.primaryFocus?.unfocus();

//     // Validate form
//     if (!_formKey.currentState!.validate()) {
//       _showErrorSnackbar('Please fix the errors above');
//       return;
//     }

//     // Check authentication
//     final userId = ref.read(currentUserIdProvider);
//     if (userId == null) {
//       _showErrorSnackbar('User not authenticated. Please login again.');
//       context.go('/login');
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       // Create form model and convert to Profile
//       final formModel = ProfileFormModel(
//         name: _nameController.text,
//         bio: _bioController.text,
//         skillsInput: _skillsController.text,
//         education: _educationController.text,
//         experience: _experienceController.text,
//         projects: _projectsController.text,
//       );

//       final profile = formModel.toProfile(userId);

//       // Submit to repository via Riverpod
//       await ref.read(createProfileProvider.notifier).createProfile(profile);

//       // Show success message
//       _showSuccessSnackbar('Profile created successfully!');

//       // Navigate to profile screen
//       if (mounted) {
//         context.go('/profile');
//       }
//     } on Exception catch (e) {
//       _showErrorSnackbar(_parseErrorMessage(e.toString()));
//     } finally {
//       if (mounted) {
//         setState(() => _isSubmitting = false);
//       }
//     }
//   }

//   /// Parse error message from exception
//   String _parseErrorMessage(String error) {
//     if (error.contains('UNAUTHENTICATED')) {
//       return 'Please login to create a profile';
//     }
//     if (error.contains('Database error')) {
//       return 'Failed to save profile. Please try again.';
//     }
//     if (error.contains('Network')) {
//       return 'Network error. Check your connection.';
//     }
//     return 'An error occurred. Please try again.';
//   }

//   /// Show error snackbar
//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(context).colorScheme.error,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }

//   /// Show success snackbar
//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green[600],
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 600;
//     final padding = isMobile ? 16.0 : 24.0;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Profile'),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.all(padding),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Header section
//                   _buildHeaderSection(padding),
//                   SizedBox(height: padding * 1.5),

//                   // Name field
//                   _buildNameField(),
//                   SizedBox(height: padding),

//                   // Bio field
//                   _buildBioField(),
//                   SizedBox(height: padding),

//                   // Skills field
//                   _buildSkillsField(),
//                   SizedBox(height: padding),

//                   // Education field
//                   _buildEducationField(),
//                   SizedBox(height: padding),

//                   // Experience field
//                   _buildExperienceField(),
//                   SizedBox(height: padding),

//                   // Projects field
//                   _buildProjectsField(),
//                   SizedBox(height: padding * 2),

//                   // Submit button
//                   _buildSubmitButton(),
//                   SizedBox(height: padding),
//                 ],
//               ),
//             ),
//           ),

//           // Loading overlay
//           if (_isSubmitting) _buildLoadingOverlay(),
//         ],
//       ),
//     );
//   }

//   /// Build header section with instructions
//   Widget _buildHeaderSection(double padding) {
//     return Container(
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primaryContainer,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Build Your Profile',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           SizedBox(height: padding / 2),
//           Text(
//             'Share your professional information to help others get to know you better.',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(context).colorScheme.onPrimaryContainer,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build name text field
//   Widget _buildNameField() {
//     return TextFormField(
//       controller: _nameController,
//       focusNode: _nameFocus,
//       decoration: InputDecoration(
//         labelText: 'Full Name *',
//         hintText: 'John Doe',
//         prefixIcon: const Icon(Icons.person),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//       ),
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) => _bioFocus.requestFocus(),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'Name is required';
//         }
//         if (value.trim().length < 2) {
//           return 'Name must be at least 2 characters';
//         }
//         if (value.trim().length > 100) {
//           return 'Name must not exceed 100 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build bio multiline text field
//   Widget _buildBioField() {
//     return TextFormField(
//       controller: _bioController,
//       focusNode: _bioFocus,
//       decoration: InputDecoration(
//         labelText: 'Bio',
//         hintText: 'Tell us about yourself...',
//         prefixIcon: const Icon(Icons.description),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//       ),
//       maxLines: 4,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) => _skillsFocus.requestFocus(),
//       validator: (value) {
//         if (value != null && value.trim().length > 500) {
//           return 'Bio must not exceed 500 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build skills comma-separated text field
//   Widget _buildSkillsField() {
//     return TextFormField(
//       controller: _skillsController,
//       focusNode: _skillsFocus,
//       decoration: InputDecoration(
//         labelText: 'Skills (optional)',
//         hintText: 'Flutter, Dart, Firebase, REST API',
//         prefixIcon: const Icon(Icons.star),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//         helperText: 'Separate skills with commas',
//       ),
//       maxLines: 2,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) => _educationFocus.requestFocus(),
//       validator: (value) {
//         if (value != null && value.trim().length > 500) {
//           return 'Skills must not exceed 500 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build education multiline text field
//   Widget _buildEducationField() {
//     return TextFormField(
//       controller: _educationController,
//       focusNode: _educationFocus,
//       decoration: InputDecoration(
//         labelText: 'Education',
//         hintText: 'Bachelor of Engineering in Computer Science...',
//         prefixIcon: const Icon(Icons.school),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//       ),
//       maxLines: 3,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) => _experienceFocus.requestFocus(),
//       validator: (value) {
//         if (value != null && value.trim().length > 500) {
//           return 'Education must not exceed 500 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build experience multiline text field
//   Widget _buildExperienceField() {
//     return TextFormField(
//       controller: _experienceController,
//       focusNode: _experienceFocus,
//       decoration: InputDecoration(
//         labelText: 'Experience',
//         hintText: 'Senior Flutter Developer at Tech Company...',
//         prefixIcon: const Icon(Icons.work),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//       ),
//       maxLines: 4,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) => _projectsFocus.requestFocus(),
//       validator: (value) {
//         if (value != null && value.trim().length > 1000) {
//           return 'Experience must not exceed 1000 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build projects multiline text field
//   Widget _buildProjectsField() {
//     return TextFormField(
//       controller: _projectsController,
//       focusNode: _projectsFocus,
//       decoration: InputDecoration(
//         labelText: 'Projects',
//         hintText: 'MemoCare - A dementia care app built with Flutter...',
//         prefixIcon: const Icon(Icons.code),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         floatingLabelBehavior: FloatingLabelBehavior.auto,
//       ),
//       maxLines: 4,
//       textInputAction: TextInputAction.done,
//       validator: (value) {
//         if (value != null && value.trim().length > 1000) {
//           return 'Projects must not exceed 1000 characters';
//         }
//         return null;
//       },
//     );
//   }

//   /// Build submit button
//   Widget _buildSubmitButton() {
//     return FilledButton(
//       onPressed: _isSubmitting ? null : _submitProfile,
//       style: FilledButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Text(
//         _isSubmitting ? 'Saving Profile...' : 'Save Profile',
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   /// Build loading overlay
//   Widget _buildLoadingOverlay() {
//     return Container(
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Creating your profile...',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
