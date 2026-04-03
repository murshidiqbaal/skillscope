import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/profile_model.dart';
import '../providers/profile_provider.dart';

// ─── Design Tokens (matches ProfileScreen) ────────────────────────────────────
class _DS {
  static const bg = Color(0xFF060D1A);
  static const surface = Color(0xFF0D1B2E);
  static const surfaceHigh = Color(0xFF112240);
  static const cyan = Color(0xFF00E5FF);
  static const violet = Color(0xFF7C3AED);
  static const orange = Color(0xFFFF6B35);
  static const green = Color(0xFF10B981);
  static const textPrimary = Color(0xFFE2F0FF);
  static const textSecondary = Color(0xFF8BA3C7);
  static const textMuted = Color(0xFF4A6080);
  static const border = Color(0xFF1E3A5F);
  static const error = Color(0xFFFF4D6D);
}

class EditProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TabController _tabController;

  // ── Basic Info
  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  // ── Career
  String _availability = 'Open to Opportunities';
  String _workPreference = 'Remote';
  late final TextEditingController _yearsExpController;
  late final TextEditingController _targetRoleController;
  late final TextEditingController _salaryController;

  // ── Skills
  late final TextEditingController _skillsController;
  late final TextEditingController _certificationsController;
  late final TextEditingController _languagesController;

  // ── Background
  late final TextEditingController _educationController;
  late final TextEditingController _experienceController;

  // ── Projects
  late final TextEditingController _projectsController;
  late final TextEditingController _openSourceController;
  late final TextEditingController _achievementsController;

  // ── Links
  late final TextEditingController _githubController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _portfolioController;
  late final TextEditingController _twitterController;
  late final TextEditingController _blogController;

  File? _imageFile;
  final _picker = ImagePicker();
  int _currentSection = 0;

  static const _tabs = ['Basic', 'Career', 'Skills', 'Background', 'Links'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(
        () => setState(() => _currentSection = _tabController.index));

    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _jobTitleController = TextEditingController(text: p.jobTitle ?? '');
    _bioController = TextEditingController(text: p.bio ?? '');
    _locationController = TextEditingController(text: p.location ?? '');
    _availability = p.availability ?? 'Open to Opportunities';
    _workPreference = p.workPreference ?? 'Remote';
    _yearsExpController =
        TextEditingController(text: p.yearsOfExperience ?? '');
    _targetRoleController = TextEditingController(text: p.targetRole ?? '');
    _salaryController =
        TextEditingController(text: p.salaryExpectation ?? '');
    _skillsController =
        TextEditingController(text: p.skills.join(', '));
    _certificationsController =
        TextEditingController(text: p.certifications ?? '');
    _languagesController =
        TextEditingController(text: p.spokenLanguages ?? '');
    _educationController =
        TextEditingController(text: p.education ?? '');
    _experienceController =
        TextEditingController(text: p.experience ?? '');
    _projectsController = TextEditingController(text: p.projects ?? '');
    _openSourceController =
        TextEditingController(text: p.openSourceContributions ?? '');
    _achievementsController =
        TextEditingController(text: p.achievements ?? '');
    _githubController = TextEditingController(text: p.githubUrl ?? '');
    _linkedinController = TextEditingController(text: p.linkedinUrl ?? '');
    _portfolioController =
        TextEditingController(text: p.portfolioUrl ?? '');
    _twitterController = TextEditingController(text: p.twitterUrl ?? '');
    _blogController = TextEditingController(text: p.blogUrl ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [
      _nameController,
      _jobTitleController,
      _bioController,
      _locationController,
      _yearsExpController,
      _targetRoleController,
      _salaryController,
      _skillsController,
      _certificationsController,
      _languagesController,
      _educationController,
      _experienceController,
      _projectsController,
      _openSourceController,
      _achievementsController,
      _githubController,
      _linkedinController,
      _portfolioController,
      _twitterController,
      _blogController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final skills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updated = widget.profile.copyWith(
      name: _nameController.text,
      jobTitle:
          _jobTitleController.text.isNotEmpty ? _jobTitleController.text : null,
      bio: _bioController.text,
      location:
          _locationController.text.isNotEmpty ? _locationController.text : null,
      availability: _availability,
      workPreference: _workPreference,
      yearsOfExperience: _yearsExpController.text.isNotEmpty
          ? _yearsExpController.text
          : null,
      targetRole: _targetRoleController.text.isNotEmpty
          ? _targetRoleController.text
          : null,
      salaryExpectation:
          _salaryController.text.isNotEmpty ? _salaryController.text : null,
      skills: skills,
      certifications: _certificationsController.text.isNotEmpty
          ? _certificationsController.text
          : null,
      spokenLanguages: _languagesController.text.isNotEmpty
          ? _languagesController.text
          : null,
      education: _educationController.text,
      experience: _experienceController.text,
      projects:
          _projectsController.text.isNotEmpty ? _projectsController.text : null,
      openSourceContributions: _openSourceController.text.isNotEmpty
          ? _openSourceController.text
          : null,
      achievements: _achievementsController.text.isNotEmpty
          ? _achievementsController.text
          : null,
      githubUrl:
          _githubController.text.isNotEmpty ? _githubController.text : null,
      linkedinUrl: _linkedinController.text.isNotEmpty
          ? _linkedinController.text
          : null,
      portfolioUrl: _portfolioController.text.isNotEmpty
          ? _portfolioController.text
          : null,
      twitterUrl:
          _twitterController.text.isNotEmpty ? _twitterController.text : null,
      blogUrl: _blogController.text.isNotEmpty ? _blogController.text : null,
    );

    await ref.read(profileProvider.notifier).updateProfile(
          profile: updated,
          newImageFile: _imageFile,
        );

    if (mounted) {
      final state = ref.read(profileProvider);
      if (state.hasError) {
        _showSnack('Failed to update: ${state.error}', isError: true);
      } else {
        _showSnack('Profile updated successfully!');
        Navigator.pop(context);
      }
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? _DS.error : _DS.green,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  style: GoogleFonts.dmSans(
                      color: _DS.textPrimary, fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: _DS.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isError ? _DS.error : _DS.green, width: 1),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileProvider).isLoading;

    return Scaffold(
      backgroundColor: _DS.bg,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: _GridPainter(),
          ),
          Column(
            children: [
              _buildAppBar(),
              _buildTabBar(),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: _DS.cyan))
                    : Form(
                        key: _formKey,
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildBasicTab(),
                            _buildCareerTab(),
                            _buildSkillsTab(),
                            _buildBackgroundTab(),
                            _buildLinksTab(),
                          ],
                        ),
                      ),
              ),
              _buildSaveBar(),
            ],
          ),
        ],
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _DS.textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: GoogleFonts.exo2(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _DS.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'SkillScope · ${_tabs[_currentSection]}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: _DS.cyan,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildProgressRing(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing() {
    final filled = _countFilledSections();
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: filled / _tabs.length,
            strokeWidth: 3,
            backgroundColor: _DS.border,
            valueColor: const AlwaysStoppedAnimation(_DS.cyan),
          ),
          Text(
            '${(filled / _tabs.length * 100).round()}%',
            style: GoogleFonts.spaceMono(
                fontSize: 9,
                color: _DS.cyan,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  int _countFilledSections() {
    int count = 0;
    if (_nameController.text.isNotEmpty) { count++; }
    if (_jobTitleController.text.isNotEmpty ||
        _targetRoleController.text.isNotEmpty) { count++; }
    if (_skillsController.text.isNotEmpty) { count++; }
    if (_educationController.text.isNotEmpty ||
        _experienceController.text.isNotEmpty) { count++; }
    if (_githubController.text.isNotEmpty ||
        _linkedinController.text.isNotEmpty ||
        _portfolioController.text.isNotEmpty) { count++; }
    return count;
  }

  // ─── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    const icons = [
      Icons.person_outline_rounded,
      Icons.work_outline_rounded,
      Icons.code_rounded,
      Icons.school_outlined,
      Icons.link_rounded,
    ];

    return Container(
      height: 64,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _DS.border),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: [
            _DS.cyan.withValues(alpha: 0.15),
            _DS.violet.withValues(alpha: 0.15),
          ]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _DS.cyan.withValues(alpha: 0.4)),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelPadding: EdgeInsets.zero,
        tabs: List.generate(
          _tabs.length,
          (i) => Tab(
            height: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[i],
                  size: 18,
                  color: _currentSection == i ? _DS.cyan : _DS.textMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  _tabs[i],
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: _currentSection == i
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color:
                        _currentSection == i ? _DS.cyan : _DS.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Save Bar ──────────────────────────────────────────────────────────────
  Widget _buildSaveBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: _DS.bg,
        border: Border(top: BorderSide(color: _DS.border)),
      ),
      child: Row(
        children: [
          if (_currentSection > 0)
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () =>
                    _tabController.animateTo(_currentSection - 1),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: _DS.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _DS.border),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: _DS.textSecondary),
                ),
              ),
            ),
          if (_currentSection > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentSection < _tabs.length - 1 ? 3 : 4,
            child: GestureDetector(
              onTap: _currentSection < _tabs.length - 1
                  ? () =>
                      _tabController.animateTo(_currentSection + 1)
                  : _saveProfile,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_DS.cyan, _DS.violet]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: _DS.cyan.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _currentSection < _tabs.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentSection < _tabs.length - 1
                            ? 'Next'
                            : 'Save Profile',
                        style: GoogleFonts.exo2(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — Basic Info
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBasicTab() {
    return _TabScroll(
      children: [
        _AvatarPicker(
          imageFile: _imageFile,
          profilePicture: widget.profile.profilePicture,
          onPick: _pickImage,
          name: widget.profile.name,
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.9, 0.9)),
        const SizedBox(height: 28),
        const _SectionLabel(label: 'IDENTITY', color: _DS.cyan),
        const SizedBox(height: 12),
        _Field(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.badge_outlined,
          accentColor: _DS.cyan,
          validator: (v) =>
              v == null || v.isEmpty ? 'Name is required' : null,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _jobTitleController,
          label: 'Job Title / Role',
          hint: 'e.g. Flutter Developer, ML Engineer',
          icon: Icons.work_outline_rounded,
          accentColor: _DS.cyan,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _locationController,
          label: 'Location',
          hint: 'City, Country',
          icon: Icons.location_on_outlined,
          accentColor: _DS.cyan,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'ABOUT YOU', color: _DS.violet),
        const SizedBox(height: 12),
        _Field(
          controller: _bioController,
          label: 'Professional Bio',
          hint: 'Tell the world what you build and care about...',
          icon: Icons.edit_note_rounded,
          accentColor: _DS.violet,
          maxLines: 5,
          validator: (v) =>
              v == null || v.isEmpty ? 'Bio is required' : null,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — Career
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCareerTab() {
    return _TabScroll(
      children: [
        const _SectionLabel(label: 'AVAILABILITY', color: _DS.green),
        const SizedBox(height: 12),
        _ChoiceChips(
          label: 'Status',
          icon: Icons.circle_notifications_outlined,
          options: const [
            'Available',
            'Open to Opportunities',
            'Not Available'
          ],
          colors: const [_DS.green, _DS.cyan, _DS.error],
          selected: _availability,
          onSelected: (v) => setState(() => _availability = v),
        ),
        const SizedBox(height: 16),
        _ChoiceChips(
          label: 'Work Preference',
          icon: Icons.home_work_outlined,
          options: const ['Remote', 'Hybrid', 'On-site'],
          colors: const [_DS.violet, _DS.cyan, _DS.orange],
          selected: _workPreference,
          onSelected: (v) => setState(() => _workPreference = v),
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'CAREER DETAILS', color: _DS.orange),
        const SizedBox(height: 12),
        _Field(
          controller: _yearsExpController,
          label: 'Years of Experience',
          hint: 'e.g. 3, 5+, 10+',
          icon: Icons.timeline_rounded,
          accentColor: _DS.orange,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _targetRoleController,
          label: 'Target / Dream Role',
          hint: 'e.g. Senior Flutter Developer at a startup',
          icon: Icons.flag_outlined,
          accentColor: _DS.orange,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _salaryController,
          label: 'Salary Expectation',
          hint: 'e.g. ₹12–18 LPA, \$80k–100k/yr',
          icon: Icons.currency_rupee_rounded,
          accentColor: _DS.orange,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — Skills
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSkillsTab() {
    final preview = _skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return _TabScroll(
      children: [
        const _SectionLabel(label: 'TECHNICAL SKILLS', color: _DS.cyan),
        const SizedBox(height: 12),
        _Field(
          controller: _skillsController,
          label: 'Skills',
          hint: 'Flutter, Dart, Python, React...',
          icon: Icons.code_rounded,
          accentColor: _DS.cyan,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
        ),
        if (preview.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SkillPreview(skills: preview),
        ],
        const SizedBox(height: 24),
        const _SectionLabel(label: 'CERTIFICATIONS', color: _DS.violet),
        const SizedBox(height: 12),
        _Field(
          controller: _certificationsController,
          label: 'Certifications',
          hint: 'Google Associate Android Developer, AWS Certified...',
          icon: Icons.verified_outlined,
          accentColor: _DS.violet,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'LANGUAGES', color: _DS.orange),
        const SizedBox(height: 12),
        _Field(
          controller: _languagesController,
          label: 'Spoken Languages',
          hint: 'English (Fluent), Malayalam (Native)...',
          icon: Icons.translate_rounded,
          accentColor: _DS.orange,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 4 — Background
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBackgroundTab() {
    return _TabScroll(
      children: [
        const _SectionLabel(label: 'EDUCATION', color: _DS.violet),
        const SizedBox(height: 12),
        _Field(
          controller: _educationController,
          label: 'Education',
          hint: 'BCA, Nirmala College (2022–2025)\nRelevant coursework...',
          icon: Icons.school_outlined,
          accentColor: _DS.violet,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'EXPERIENCE', color: _DS.cyan),
        const SizedBox(height: 12),
        _Field(
          controller: _experienceController,
          label: 'Work Experience',
          hint:
              'Flutter Developer Intern @ XYZ (Jun–Aug 2024)\n• Built...',
          icon: Icons.work_history_outlined,
          accentColor: _DS.cyan,
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(
            label: 'PROJECTS & CONTRIBUTIONS', color: _DS.orange),
        const SizedBox(height: 12),
        _Field(
          controller: _projectsController,
          label: 'Projects',
          hint:
              'MemoCare – Dementia care app (Flutter + Supabase)\nSkillScope AI – ...',
          icon: Icons.rocket_launch_outlined,
          accentColor: _DS.orange,
          maxLines: 5,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _openSourceController,
          label: 'Open Source Contributions',
          hint:
              'flutter/flutter – fixed issue #1234\npub.dev package author...',
          icon: Icons.hub_outlined,
          accentColor: _DS.orange,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'ACHIEVEMENTS', color: _DS.green),
        const SizedBox(height: 12),
        _Field(
          controller: _achievementsController,
          label: 'Awards & Achievements',
          hint:
              'Winner – State Hackathon 2024\nPublished 3 Flutter packages...',
          icon: Icons.emoji_events_outlined,
          accentColor: _DS.green,
          maxLines: 3,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 5 — Links
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildLinksTab() {
    return _TabScroll(
      children: [
        const _SectionLabel(label: 'CODE & PORTFOLIO', color: _DS.cyan),
        const SizedBox(height: 12),
        _Field(
          controller: _githubController,
          label: 'GitHub',
          hint: 'https://github.com/username',
          icon: Icons.code_rounded,
          accentColor: _DS.cyan,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _portfolioController,
          label: 'Portfolio Website',
          hint: 'https://yourname.dev',
          icon: Icons.language_rounded,
          accentColor: _DS.cyan,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'PROFESSIONAL', color: _DS.violet),
        const SizedBox(height: 12),
        _Field(
          controller: _linkedinController,
          label: 'LinkedIn',
          hint: 'https://linkedin.com/in/username',
          icon: Icons.people_outline_rounded,
          accentColor: _DS.violet,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 24),
        const _SectionLabel(label: 'SOCIAL & CONTENT', color: _DS.orange),
        const SizedBox(height: 12),
        _Field(
          controller: _twitterController,
          label: 'X / Twitter',
          hint: 'https://x.com/username',
          icon: Icons.alternate_email_rounded,
          accentColor: _DS.orange,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _blogController,
          label: 'Blog / Dev.to / Medium',
          hint: 'https://dev.to/username',
          icon: Icons.rss_feed_rounded,
          accentColor: _DS.orange,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        _LinksPreview(
          github: _githubController.text,
          linkedin: _linkedinController.text,
          portfolio: _portfolioController.text,
          twitter: _twitterController.text,
          blog: _blogController.text,
        ),
      ],
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _TabScroll extends StatelessWidget {
  final List<Widget> children;
  const _TabScroll({required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            color: color,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final Color accentColor;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    required this.accentColor,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _DS.border),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: GoogleFonts.dmSans(color: _DS.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(color: _DS.textMuted, fontSize: 13),
          labelStyle:
              GoogleFonts.dmSans(color: _DS.textSecondary, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: GoogleFonts.dmSans(color: _DS.error, fontSize: 11),
          floatingLabelStyle:
              GoogleFonts.dmSans(color: accentColor, fontSize: 12),
        ),
      ),
    );
  }
}

class _ChoiceChips extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final List<Color> colors;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChoiceChips({
    required this.label,
    required this.icon,
    required this.options,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _DS.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _DS.textMuted, size: 16),
              const SizedBox(width: 8),
              Text(label,
                  style: GoogleFonts.dmSans(
                      color: _DS.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(options.length, (i) {
              final isSelected = selected == options[i];
              final color = colors[i];
              return GestureDetector(
                onTap: () => onSelected(options[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : _DS.surfaceHigh,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? color : _DS.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: color.withValues(alpha: 0.2),
                                blurRadius: 8)
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(Icons.check_rounded, size: 13, color: color),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        options[i],
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected ? color : _DS.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SkillPreview extends StatelessWidget {
  final List<String> skills;
  const _SkillPreview({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _DS.cyan.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _DS.cyan.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.preview_rounded, size: 13, color: _DS.cyan),
              const SizedBox(width: 6),
              Text('Preview',
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: _DS.cyan, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skills
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _DS.surfaceHigh,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _DS.cyan.withValues(alpha: 0.2)),
                      ),
                      child: Text(s,
                          style: GoogleFonts.dmSans(
                              color: _DS.cyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinksPreview extends StatelessWidget {
  final String github, linkedin, portfolio, twitter, blog;
  const _LinksPreview({
    required this.github,
    required this.linkedin,
    required this.portfolio,
    required this.twitter,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    final filled = [github, linkedin, portfolio, twitter, blog]
        .where((s) => s.isNotEmpty)
        .length;
    if (filled == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _DS.orange.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _DS.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: _DS.green, size: 18),
          const SizedBox(width: 10),
          Text(
            '$filled link${filled > 1 ? 's' : ''} added to your profile',
            style: GoogleFonts.dmSans(
                color: _DS.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final File? imageFile;
  final String? profilePicture;
  final VoidCallback onPick;
  final String? name;
  const _AvatarPicker(
      {this.imageFile,
      this.profilePicture,
      required this.onPick,
      this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPick,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: _DS.cyan.withValues(alpha: 0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                      color: _DS.cyan.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 2),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: _DS.surfaceHigh,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!) as ImageProvider
                    : (profilePicture != null && profilePicture!.isNotEmpty
                        ? CachedNetworkImageProvider(profilePicture!)
                        : null),
                child: (imageFile == null &&
                        (profilePicture == null ||
                            profilePicture!.isEmpty))
                    ? Text(
                        (name ?? 'S').substring(0, 1).toUpperCase(),
                        style: GoogleFonts.exo2(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: _DS.cyan,
                        ),
                      )
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_DS.cyan, _DS.violet]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: _DS.cyan.withValues(alpha: 0.4),
                      blurRadius: 8),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid Background ──────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D2040).withValues(alpha: 0.5)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
