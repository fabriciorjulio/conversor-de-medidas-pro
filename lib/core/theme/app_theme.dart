import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette spec
  static const Color primary = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color surface = Color(0xFFE3F2FD);
  static const Color background = Color(0xFFFAFAFA);
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF212121);
  static const Color resultGreen = Color(0xFF00897B);
  static const Color errorColor = Color(0xFFB00020);

  // Legacy aliases kept for compatibility
  static const Color primaryBlue = primary;
  static const Color lightBlue = secondary;
  static const Color darkBlue = Color(0xFF01579B);

  static TextTheme _buildTextTheme() {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w800, color: onBackground),
      headlineMedium: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w700, color: onBackground),
      bodyLarge: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: onBackground),
      labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, color: onBackground),
      bodySmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF757575)),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: errorColor,
        onPrimary: onPrimary,
        onSurface: onBackground,
      ),
      scaffoldBackgroundColor: background,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE3F2FD), width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE3F2FD), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE3F2FD), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
