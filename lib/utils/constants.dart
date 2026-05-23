import 'package:flutter/material.dart';

// Couleurs a utilisr dans l'application
class AppColors {
  static const Color primary = Color(0xFF6C63FF);    // le bleu pricipal pour les éléments interactifs
  static const Color background = Color(0xFFF5F7FA); // Fond de l'app
  static const Color textDarkPrimary = Color(0xFF1F2937); // Texte principal
  static const Color textDarkSecondary = Color(0xFF6B7280);   // Texte secondaire
  static const Color priorityHigh = Color(0xFFEF4444);   // Texte secondaire
  static const Color priorityMedium = Color(0xFFF59E0B);   // Texte secondaire
  static const Color priorityLow = Color(0xFF10B981);   // Texte secondaire

}

// Les Thèmes de l'application
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 1,
        iconTheme: IconThemeData(color: AppColors.textDarkPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textDarkPrimary, 
          fontSize: 20, 
          fontWeight: FontWeight.w600
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
      ),
    );
  }
}