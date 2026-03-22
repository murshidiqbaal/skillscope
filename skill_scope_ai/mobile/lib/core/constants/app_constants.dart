import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'SkillScope AI';

  // API Endpoints
  // ▸ USB Debugging (adb reverse) → 'http://localhost:8000'  ✅ ACTIVE
  // ▸ Android Emulator            → 'http://10.0.2.2:8000'
  // ▸ Physical Device (WiFi)      → 'http://<YOUR_PC_IP>:8000'
  static const String fastapiBaseUrl = 'http://localhost:8000';

  // Supabase (Replace with actual values or load via env)
  static const String supabaseUrl = 'https://jkgvjtnlmvvafyvmohjv.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprZ3ZqdG5sbXZ2YWZ5dm1vaGp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NTM2OTYsImV4cCI6MjA4OTQyOTY5Nn0.94lIiDdgyT-9_Oo2fQB9Qcvzt7-_yMDLaocRs8RbOkM';

  // Colors
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color secondaryColor = Color(0xFF625B71);
  static const Color surfaceColor = Color(0xFFFEF7FF);
  static const Color backgroundColor = Color(0xFFF3EDF7);
}
