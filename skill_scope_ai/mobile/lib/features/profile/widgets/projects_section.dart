// ============================================================================
// SKILLS SECTION WIDGET
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;
  final VoidCallback? onAddSkill;

  const SkillsSection({
    Key? key,
    this.skills = const [
      'Flutter',
      'Dart',
      'Firebase',
      'REST APIs',
      'UI Design',
      'Riverpod',
      'GoRouter',
      'Git',
    ],
    this.onAddSkill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: List.generate(skills.length, (index) {
              return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4F46E5).withOpacity(0.2),
                          const Color(0xFF06B6D4).withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFF06B6D4).withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      skills[index],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                      ),
                    ),
                  )
                  .animate()
                  .scale(
                    begin: Offset(0.6, 0.6),
                    end: Offset(1, 1),
                    delay: Duration(milliseconds: 50 + (index * 50)),
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 400.ms);
            }),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EDUCATION SECTION WIDGET
// ============================================================================

class EducationSection extends StatelessWidget {
  final List<Map<String, String>> education;

  const EducationSection({
    Key? key,
    this.education = const [
      {
        'degree': 'Bachelor of Science',
        'field': 'Computer Science',
        'school': 'Stanford University',
        'year': '2020',
      },
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(education.length, (index) {
            final edu = education[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:
                  Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1E293B).withOpacity(0.5),
                              const Color(0xFF0F172A).withOpacity(0.7),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF06B6D4).withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF4F46E5).withOpacity(0.2),
                                    const Color(0xFF8B5CF6).withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFF06B6D4,
                                  ).withOpacity(0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Color(0xFF06B6D4),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    edu['degree'] ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    edu['field'] ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF06B6D4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${edu['school']} • ${edu['year']}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        delay: Duration(milliseconds: 100 + (index * 50)),
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 400.ms),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// EXPERIENCE SECTION WIDGET
// ============================================================================

class ExperienceSection extends StatelessWidget {
  final List<Map<String, String>> experience;

  const ExperienceSection({
    Key? key,
    this.experience = const [
      {
        'title': 'Senior Flutter Developer',
        'company': 'Tech Company Inc',
        'duration': 'Jan 2022 - Present',
        'description': 'Led development of mobile applications using Flutter',
      },
      {
        'title': 'Flutter Developer',
        'company': 'Startup XYZ',
        'duration': 'Jun 2020 - Dec 2021',
        'description': 'Built and maintained multiple Flutter applications',
      },
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(experience.length, (index) {
            final exp = experience[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:
                  Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1E293B).withOpacity(0.5),
                              const Color(0xFF0F172A).withOpacity(0.7),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF06B6D4).withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF4F46E5,
                                        ).withOpacity(0.2),
                                        const Color(
                                          0xFF8B5CF6,
                                        ).withOpacity(0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF06B6D4,
                                      ).withOpacity(0.2),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.work_rounded,
                                    color: Color(0xFF06B6D4),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp['title'] ?? '',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        exp['company'] ?? '',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: const Color(0xFF06B6D4),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              exp['duration'] ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exp['description'] ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[400],
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        delay: Duration(milliseconds: 150 + (index * 50)),
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 400.ms),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// PROJECTS SECTION WIDGET
// ============================================================================

class ProjectsSection extends StatelessWidget {
  final List<Map<String, String>> projects;

  const ProjectsSection({
    Key? key,
    this.projects = const [
      {
        'title': 'SkillScope AI',
        'description': 'A mobile app for analyzing trending skills',
        'tech': 'Flutter, Firebase, AI',
      },
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(projects.length, (index) {
            final proj = projects[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:
                  Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1E293B).withOpacity(0.5),
                              const Color(0xFF0F172A).withOpacity(0.7),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF06B6D4).withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proj['title'] ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              proj['description'] ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[400],
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: (proj['tech'] ?? '').split(', ').map((
                                tech,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF4F46E5,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF06B6D4,
                                      ).withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    tech,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        delay: Duration(milliseconds: 200 + (index * 50)),
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 400.ms),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// SOCIAL LINKS SECTION WIDGET
// ============================================================================

class SocialLinksSection extends StatelessWidget {
  final List<Map<String, dynamic>> socialLinks;

  const SocialLinksSection({
    Key? key,
    this.socialLinks = const [
      {
        'icon': Icons.language_rounded,
        'label': 'Portfolio',
        'url': 'https://example.com',
        'color': Color(0xFF06B6D4),
      },
      {
        'icon': Icons.code_rounded,
        'label': 'GitHub',
        'url': 'https://github.com',
        'color': Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.business_center_rounded,
        'label': 'LinkedIn',
        'url': 'https://linkedin.com',
        'color': Color(0xFF4F46E5),
      },
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Links',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(socialLinks.length, (index) {
              final link = socialLinks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child:
                    Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                link['color'].withOpacity(0.2),
                                link['color'].withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: (link['color'] as Color).withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (link['color'] as Color).withOpacity(
                                  0.1,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  link['icon'] as IconData,
                                  color: link['color'] as Color,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scale(
                          begin: Offset(0.6, 0.6),
                          end: Offset(1, 1),
                          delay: Duration(milliseconds: 250 + (index * 50)),
                          duration: 400.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: 400.ms),
              );
            }),
          ),
        ],
      ),
    );
  }
}
