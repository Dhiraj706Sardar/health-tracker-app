import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryBlue = Color(0xFF1E88E5);

  // Accent colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // Background colors - Light theme
  static const Color scaffoldLight = Color(0xFFFAFBFC);
  static const Color cardLight = Colors.white;
  static const Color cardGradientLight1 = Colors.white;
  static const Color cardGradientLight2 = Color(0xFFF8F9FA);
  static const Color inputFillLight = Color(0xFFF8F9FA);

  // Background colors - Dark theme
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color cardGradientDark1 = Color(0xFF1E1E1E);
  static const Color cardGradientDark2 = Color(0xFF2A2A2A);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;

  // Border colors
  static const Color borderLight = Color(0xFFE3E8EF);
  static const Color borderGrey = Colors.grey;

  // Login gradient
  static List<Color> loginGradient(BuildContext context) => [
    Colors.blue.shade400,
    Colors.blue.shade800,
  ];

  // Profile card gradient
  static const List<Color> profileGradientLight = [
    Color(0xFF42A5F5),
    Color(0xFF1E88E5),
  ];

  static const List<Color> profileGradientDark = [
    Color(0xFF1E88E5),
    Color(0xFF1565C0),
  ];

  // Menu card colors
  static const Color menuHealthGraph = Color(0xFF4CAF50);
  static const Color menuActivityLogs = Color(0xFFFF9800);

  // Chart colors
  static const Color chartBlue = Colors.blue;
  static const Color chartGrey = Colors.grey;
}
