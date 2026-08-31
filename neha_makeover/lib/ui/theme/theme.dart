import 'package:flutter/material.dart';

class AppTheme {
  // Luxury Palette
  static const Color ivory = Color(0xFFFAF9F6);
  static const Color blush = Color(0xFFF2D5D5);
  static const Color roseGold = Color(0xFFB76E79);
  static const Color champagne = Color(0xFFF7E7CE);
  static const Color mutedMauve = Color(0xFFC0A0B0);
  static const Color deepPlum = Color(0xFF4A2545);
  static const Color darkCharcoal = Color(0xFF2C2C2C);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: ivory,
      colorScheme: const ColorScheme.light(
        primary: deepPlum,
        secondary: roseGold,
        surface: ivory,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkCharcoal,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: deepPlum, fontWeight: FontWeight.w300, fontSize: 32),
        displayMedium: TextStyle(color: deepPlum, fontWeight: FontWeight.w400, fontSize: 28),
        headlineMedium: TextStyle(color: darkCharcoal, fontWeight: FontWeight.w500, fontSize: 22),
        bodyLarge: TextStyle(color: darkCharcoal, fontSize: 16),
        bodyMedium: TextStyle(color: darkCharcoal, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepPlum,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepPlum,
          side: const BorderSide(color: deepPlum),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(13), // 0.05 * 255
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: roseGold, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: deepPlum,
        unselectedItemColor: mutedMauve,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      useMaterial3: true,
    );
  }
}
