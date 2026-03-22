import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumeUploadCard extends StatelessWidget {
  const ResumeUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Slate
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: Color(0xFF8B5CF6),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Upload your resume",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "PDF or DOCX (Max 5MB)",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
