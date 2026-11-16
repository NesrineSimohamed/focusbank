import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors matching the FocusBank presentation
  static const Color primaryGold = Color(0xFFF5BA13);
  static const Color goldLight = Color(0xFFFFD562);
  static const Color goldDark = Color(0xFFC7920A);
  
  static const Color bgDark = Color(0xFF0E0E12);
  static const Color surfaceDark = Color(0xFF18181F);
  static const Color surfaceCard = Color(0xFF1F1F28);
  static const Color surfaceBorder = Color(0xFF2C2C38);
  
  static const Color textWhite = Color(0xFFF6F6F8);
  static const Color textMuted = Color(0xFF8F8F9D);
  static const Color textDim = Color(0xFF5E5E6B);
  
  static const Color depositGreen = Color(0xFF2ED573);
  static const Color withdrawRed = Color(0xFFFF4757);
  static const Color infoBlue = Color(0xFF1E90FF);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryGold,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: goldLight,
        surface: surfaceDark,
        onPrimary: Colors.black,
        onSurface: textWhite,
      ),
      fontFamily: 'Segoe UI', // Clean Windows & cross-platform default
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: primaryGold),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: surfaceBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryGold,
        unselectedItemColor: textDim,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
