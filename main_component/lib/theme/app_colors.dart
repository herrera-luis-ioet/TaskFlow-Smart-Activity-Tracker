import 'package:flutter/material.dart';

/// AppColors defines the color palette for the TaskFlow application.
///
/// This class provides static access to all colors used throughout the app,
/// ensuring consistency in the UI. It includes colors for both light and dark themes.
class AppColors {
  // Primary colors
  static const Color primaryLight = Color(0xFF4A6FFF);
  static const Color primaryDark = Color(0xFF738AFF);
  
  // Secondary colors
  static const Color secondaryLight = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF03DAC6);
  
  // Accent colors
  static const Color accentLight = Color(0xFFFF7597);
  static const Color accentDark = Color(0xFFFF8FAF);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color backgroundDark = Color(0xFF121212);
  
  // Surface colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Error colors
  static const Color errorLight = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  
  // Text colors
  static const Color textPrimaryLight = Color(0xFF1D1D1D);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
  
  // Task priority colors
  static const Color highPriority = Color(0xFFFF5252);
  static const Color mediumPriority = Color(0xFFFFB74D);
  static const Color lowPriority = Color(0xFF66BB6A);
  
  // Task status colors
  static const Color completed = Color(0xFF66BB6A);
  static const Color inProgress = Color(0xFF42A5F5);
  static const Color notStarted = Color(0xFF9E9E9E);
  static const Color overdue = Color(0xFFFF5252);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF4A6FFF),
    Color(0xFF738AFF),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFF7597),
    Color(0xFFFF8FAF),
  ];
}