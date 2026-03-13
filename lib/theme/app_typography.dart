import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system using Outfit for display/headlines and Plus Jakarta Sans for body
abstract class AppTypography {
  static String? get fontFamily => GoogleFonts.plusJakartaSans().fontFamily;
  static String? get displayFontFamily => GoogleFonts.outfit().fontFamily;

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.outfit(
      fontSize: 57, fontWeight: FontWeight.w600, letterSpacing: -0.5, height: 1.12,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: 45, fontWeight: FontWeight.w600, letterSpacing: -0.25, height: 1.16,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: 36, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.22,
    ),
    headlineLarge: GoogleFonts.outfit(
      fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.25, height: 1.25,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.15, height: 1.29,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0, height: 1.33,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.27,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.50,
    ),
    titleSmall: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.43,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, height: 1.50,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.43,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.33,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43,
    ),
    labelMedium: GoogleFonts.plusJakartaSans(
      fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.33,
    ),
    labelSmall: GoogleFonts.plusJakartaSans(
      fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.45,
    ),
  );

  static TextTheme applyColor(TextTheme textTheme, Color color) {
    return textTheme.apply(bodyColor: color, displayColor: color);
  }
}
