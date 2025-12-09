import 'package:flutter/material.dart';

class AppTheme {
  // Define your base colors (CSS variables)
  static const Color primaryColor = Color(0xFF448AFF); // BlueAccent
  static const Color secondaryColor = Color(0xFFF5F5F5); // Light Grey
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,

      // Standardize Text Styles (H1, H2, p, etc.)
      textTheme: const TextTheme(
        titleLarge: TextStyle( // Used for Product Titles
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyMedium: TextStyle( // Used for Descriptions/Subtitles
          fontSize: 12,
          color: textLight,
        ),
        headlineMedium: TextStyle( // Used for Price
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),

      // Standardize Card/Button shapes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}