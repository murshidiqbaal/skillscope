import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/resume_analysis_model.dart';
import '../provider/resume_validator_provider.dart';

/// Widget for displaying resume analysis results
class AnalysisResultWidget extends ConsumerWidget {
  final ResumeAnalysis analysis;

  const AnalysisResultWidget({Key? key, required this.analysis})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Job role header
          _buildJobRoleHeader(context),
          const SizedBox(height: 24),

          // Match score card
          _buildMatchScoreCard(context),
          const SizedBox(height: 24),

          // Detected skills section
          _buildDetectedSkillsSection(context),
          const SizedBox(height: 24),

          // Missing skills section
          _buildMissingSkillsSection(context),
          const SizedBox(height: 24),

          // Learning resources section
          if (analysis.recommendedResources.isNotEmpty)
            _buildLearningResourcesSection(context),

          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  /// Build job role header
  Widget _buildJobRoleHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Role',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            analysis.jobRole,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// Build match score card with circular progress
  Widget _buildMatchScoreCard(BuildContext context) {
    final matchScore = analysis.matchScore;
    final scoreColor = _getScoreColor(matchScore);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Match Score',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Circular progress indicator
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                  ),

                  // Progress arc
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: matchScore / 100,
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),

                  // Score text
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$matchScore%',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                        ),
                        Text(
                          _getScoreLabel(matchScore),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score description
            Text(
              _getScoreDescription(matchScore),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build detected skills section
  Widget _buildDetectedSkillsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Detected Skills',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${analysis.detectedSkills.length}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Skills chips
        _buildSkillsChips(
          context,
          analysis.detectedSkills,
          Colors.green,
          Icons.check,
        ),
      ],
    );
  }

  /// Build missing skills section
  Widget _buildMissingSkillsSection(BuildContext context) {
    final hasMissingSkills = analysis.missingSkills.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Missing Skills',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (hasMissingSkills)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${analysis.missingSkills.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Skills or empty state
        if (hasMissingSkills)
          _buildSkillsChips(
            context,
            analysis.missingSkills,
            Colors.orange,
            Icons.warning,
          )
        else
          _buildEmptyState(
            context,
            'Great! You have all the required skills for this role.',
            Icons.celebration,
            Colors.green,
          ),
      ],
    );
  }

  /// Build learning resources section
  Widget _buildLearningResourcesSection(BuildContext context) {
    final resources = analysis.recommendedResources;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(Icons.school, color: Colors.blue[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Recommended Learning Resources',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Resources list
        Column(
          children: List.generate(
            resources.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < resources.length - 1 ? 12 : 0,
              ),
              child: _buildResourceCard(context, resources[index]),
            ),
          ),
        ),
      ],
    );
  }

  /// Build single resource card
  Widget _buildResourceCard(BuildContext context, LearningResource resource) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (resource.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        resource.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (resource.platform != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        resource.platform!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildLearnButton(context, resource.url),
          ],
        ),
      ),
    );
  }

  /// Build learn button
  Widget _buildLearnButton(BuildContext context, String url) {
    return FilledButton.tonal(
      onPressed: () => _launchUrl(url),
      child: const Text('Learn'),
    );
  }

  /// Build skills chips
  Widget _buildSkillsChips(
    BuildContext context,
    List<String> skills,
    Color color,
    IconData icon,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        skills.length,
        (index) => Chip(
          avatar: Icon(icon, size: 16),
          label: Text(skills[index]),
          backgroundColor: color.withOpacity(0.1),
          labelStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => ref.read(resumeAnalysisProvider.notifier).reset(),
            child: const Text('Analyze Again'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () {
              // Navigate or share results
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Results saved!')));
            },
            child: const Text('Save Results'),
          ),
        ),
      ],
    );
  }

  /// Get color based on match score
  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  /// Get label based on match score
  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }

  /// Get description based on match score
  String _getScoreDescription(int score) {
    if (score >= 80) {
      return 'You have a great match for this role!';
    } else if (score >= 60) {
      return 'You have good experience for this role. Consider learning the missing skills.';
    } else if (score >= 40) {
      return 'You have some relevant skills. Focus on learning the missing skills.';
    } else {
      return 'You need to develop more skills for this role.';
    }
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
