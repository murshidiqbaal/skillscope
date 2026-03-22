import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../provider/resume_validator_provider.dart';

/// Premium Resume Upload Card
class ResumeUploadCard extends ConsumerStatefulWidget {
  const ResumeUploadCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ResumeUploadCard> createState() => _ResumeUploadCardState();
}

class _ResumeUploadCardState extends ConsumerState<ResumeUploadCard> {
  bool _isHovered = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final name = result.files.single.name;
      final extension = name.split('.').last.toLowerCase();
      
      ref.read(resumeFilePathProvider.notifier).state = path;
      ref.read(resumeFileTypeProvider.notifier).state = extension;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filePath = ref.watch(resumeFilePathProvider);
    final fileName = filePath?.split('\\').last.split('/').last;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _pickFile,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: filePath != null 
                  ? const Color(0xFF10B981) 
                  : (_isHovered ? const Color(0xFF06B6D4) : Colors.white.withOpacity(0.1)),
              width: 1.5,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            children: [
              // Icon with animated background
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (filePath != null ? const Color(0xFF10B981) : const Color(0xFF06B6D4)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  filePath != null ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                  color: filePath != null ? const Color(0xFF10B981) : const Color(0xFF06B6D4),
                  size: 40,
                ),
              ).animate(target: _isHovered ? 1 : 0)
               .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
              
              const SizedBox(height: 24),
              
              // Text Content
              Text(
                filePath != null ? 'Resume Selected' : 'Upload Your Resume',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                filePath != null ? fileName! : 'Supports PDF, DOC, DOCX (Max 5MB)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              
              if (filePath == null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Browse Files',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
