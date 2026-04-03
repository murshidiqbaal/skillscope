import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/skills_provider.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => ref.read(skillsProvider.notifier).setSearchQuery(value),
        style: GoogleFonts.plusJakartaSans(color: Colors.white),
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Color(0xFF4F46E5)),
          hintText: "Search trending skills...",
          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
