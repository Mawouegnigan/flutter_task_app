import 'package:flutter/material.dart';

// Couleurs a utilisr dans l'application
class AppColors {
  static const Color primary = Color(0xFF6C63FF);    // le bleu pricipal pour les éléments interactifs
  static const Color background = Color(0xFFF5F7FA); // Fond de l'app
  static const Color textDarkPrimary = Color(0xFF1F2937); // Texte principal
  static const Color textDarkSecondary = Color(0xFF6B7280);   // Texte secondaire
     // Texte principal
}

// Les Thèmes de l'application
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
      ),
    );
  }
}