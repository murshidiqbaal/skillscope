import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Profile Header Widget
///
/// Features:
/// - Circular avatar with gradient border
/// - User name and bio
/// - Location/role information
/// - Edit and download buttons
/// - Smooth animations
class ProfileHeader extends StatelessWidget {
  final String name;
  final String title;
  final String bio;
  final String location;
  final String? avatarUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDownload;

  const ProfileHeader({
    Key? key,
    this.name = 'John Doe',
    this.title = 'Flutter Developer | AI Enthusiast',
    this.bio =
        'Building beautiful mobile apps with Flutter. Passionate about clean code and user experience.',
    this.location = 'San Francisco, CA',
    this.avatarUrl,
    this.onEdit,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
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
      ),
      child: Column(
        children: [
          // Avatar with gradient border
          Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [const Color(0xFF4F46E5), const Color(0xFF06B6D4)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? CachedNetworkImage(
                            imageUrl: avatarUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _buildAvatarPlaceholder(),
                            errorWidget: (context, url, error) =>
                                _buildAvatarPlaceholder(),
                          )
                        : _buildAvatarPlaceholder(),
                  ),
                ),
              )
              .animate()
              .scale(
                begin: Offset(0.8, 0.8),
                end: Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 500.ms),

          const SizedBox(height: 24),

          // Name
          Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              )
              .animate()
              .slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 100.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),

          const SizedBox(height: 8),

          // Title/Role
          Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF06B6D4),
                  letterSpacing: 0.3,
                ),
              )
              .animate()
              .slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 150.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),

          const SizedBox(height: 12),

          // Bio
          Text(
                bio,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[400],
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              )
              .animate()
              .slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),

          const SizedBox(height: 12),

          // Location
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF06B6D4),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    location,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              .animate()
              .slideY(
                begin: 0.2,
                duration: 600.ms,
                delay: 250.ms,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: 500.ms),

          const SizedBox(height: 28),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Edit Profile Button
              _buildActionButton(
                label: 'Edit Profile',
                icon: Icons.edit_rounded,
                isPrimary: true,
                onTap: onEdit,
                delay: 300.ms,
              ),
              const SizedBox(width: 16),
              // Download Resume Button
              _buildActionButton(
                label: 'Download',
                icon: Icons.download_rounded,
                isPrimary: false,
                onTap: onDownload,
                delay: 350.ms,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build avatar placeholder
  Widget _buildAvatarPlaceholder() {
    return Container(
      color: const Color(0xFF1E293B),
      child: const Center(
        child: Icon(Icons.person_rounded, color: Color(0xFF06B6D4), size: 60),
      ),
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    VoidCallback? onTap,
    required Duration delay,
  }) {
    return Container(
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
                  )
                : null,
            border: !isPrimary
                ? Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.5),
                    width: 1.5,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isPrimary ? Colors.white : const Color(0xFF06B6D4),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isPrimary
                            ? Colors.white
                            : const Color(0xFF06B6D4),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .scale(
          begin: Offset(0.8, 0.8),
          end: Offset(1, 1),
          delay: delay,
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(delay: delay, duration: 400.ms);
  }
}
