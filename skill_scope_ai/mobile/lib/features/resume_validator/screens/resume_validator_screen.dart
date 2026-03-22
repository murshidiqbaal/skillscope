import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/resume_analysis_model.dart';
import '../provider/resume_validator_provider.dart';
import '../widgets/job_role_input.dart';
import '../widgets/learning_resource_card.dart';
import '../widgets/match_score_widget.dart';
import '../widgets/resume_upload_card.dart';
import '../widgets/skill_chip.dart';

/// Premium Animated Resume Validator Screen
class ResumeValidatorScreen extends ConsumerWidget {
  const ResumeValidatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(resumeAnalysisProvider);
    final isLoading = analysisAsync.isLoading;
    final result = analysisAsync.value;
    final hasResult = result != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Navy
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              const Color(0xFF4F46E5).withOpacity(0.15), // Indigo
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Header
                _buildAnimatedHeader()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(
                      begin: -0.2,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 40),

                // Job Role Input
                const JobRoleInput()
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(
                      begin: 0.2,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 24),

                // Resume Upload Card
                const ResumeUploadCard()
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(
                      begin: 0.2,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 32),

                // Analyze Button
                _buildPremiumAnalyzeButton(context, ref, isLoading)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(
                      begin: 0.2,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                // Results Section (if available)
                if (hasResult) ...[
                  const SizedBox(height: 48),

                  // Match Score Section
                  _buildMatchScoreSection(result)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideY(
                        begin: 0.3,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 40),

                  // Detected Skills Section
                  _buildDetectedSkillsSection(result)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .slideY(
                        begin: 0.3,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 32),

                  // Missing Skills Section
                  _buildMissingSkillsSection(result)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .slideY(
                        begin: 0.3,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 40),

                  // Recommendations Section
                  _buildRecommendationsSection(result)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 700.ms)
                      .slideY(
                        begin: 0.3,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 48),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build animated header with gradient background
  Widget _buildAnimatedHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.1),
            const Color(0xFF8B5CF6).withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF06B6D4).withOpacity(0.1),
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SkillScope AI Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.3),
                      const Color(0xFF8B5CF6).withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: Color(0xFF06B6D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "SkillScope AI",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            "Resume Validator",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            "Analyze your resume and discover the skills needed for your dream role",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: Colors.grey[400],
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build premium analyze button
  Widget _buildPremiumAnalyzeButton(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => _analyzeResume(context, ref),
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Analyze Resume",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Analyze resume logic
  Future<void> _analyzeResume(BuildContext context, WidgetRef ref) async {
    final jobRole = ref.read(jobRoleProvider);
    final resumeFile = ref.read(resumeFilePathProvider);
    final fileType = ref.read(resumeFileTypeProvider);

    if (jobRole.trim().isEmpty) {
      _showError(context, 'Please enter a job role');
      return;
    }

    if (resumeFile == null || resumeFile.isEmpty) {
      _showError(context, 'Please select a resume file');
      return;
    }

    if (fileType == null || fileType.isEmpty) {
      _showError(context, 'Unable to determine file type');
      return;
    }

    try {
      await ref.read(resumeAnalysisProvider.notifier).analyzeResume(
        jobRole: jobRole,
        resumeFilePath: resumeFile,
        fileType: fileType,
      );
    } catch (e) {
      _showError(context, 'An unexpected error occurred during analysis');
    }
  }

  /// Show error snackbar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Build match score section with animated card
  Widget _buildMatchScoreSection(ResumeAnalysis result) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B).withOpacity(0.6),
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF06B6D4).withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Job Match Score",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green[400]!.withOpacity(0.2),
                      Colors.green[600]!.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.green[400]!.withOpacity(0.4),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${result.matchScore}% Match",
                  style: TextStyle(
                    color: Colors.green[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          MatchScoreWidget(score: result.matchScore / 100)
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),
        ],
      ),
    );
  }

  /// Build detected skills section
  Widget _buildDetectedSkillsSection(ResumeAnalysis result) {
    final skills = result.detectedSkills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.verified_rounded,
          title: "Detected Skills",
          subtitle: "${skills.length} skills found in your resume",
          color: Colors.green[400]!,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: List.generate(skills.length, (index) {
            return SkillChip(label: skills[index], isMissing: false)
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  delay: Duration(milliseconds: 50 + (index * 50)),
                  duration: 400.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 50 + (index * 50)),
                );
          }),
        ),
      ],
    );
  }

  /// Build missing skills section
  Widget _buildMissingSkillsSection(ResumeAnalysis result) {
    final skills = result.missingSkills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.warning_amber_rounded,
          title: "Missing Skills",
          subtitle: "${skills.length} skills to improve your profile",
          color: Colors.orange[400]!,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: List.generate(skills.length, (index) {
            return SkillChip(label: skills[index], isMissing: true)
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  delay: Duration(milliseconds: 50 + (index * 50)),
                  duration: 400.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 50 + (index * 50)),
                );
          }),
        ),
      ],
    );
  }

  /// Build recommendations section
  Widget _buildRecommendationsSection(ResumeAnalysis result) {
    final recommendations = result.recommendedResources;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.library_books_outlined,
          title: "Recommended Learning",
          subtitle: "Resources to fill your skill gaps",
          color: const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 16),
        ...List.generate(recommendations.length, (index) {
          return LearningResourceCard(resource: recommendations[index]);
        }),
      ],
    );
  }


  /// Build section header with icon
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
