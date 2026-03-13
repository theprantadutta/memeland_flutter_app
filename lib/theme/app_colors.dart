import 'package:flutter/material.dart';

/// Memeland brand color palette - vibrant meme-friendly colors
abstract class AppColors {
  // Brand Primary Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color deepPurple = Color(0xFF6C3FAF);
  static const Color electricBlue = Color(0xFF00B4D8);

  // Extended palette
  static const Color goldLight = Color(0xFFFFE44D);
  static const Color goldDark = Color(0xFFCCAA00);
  static const Color deepPurpleLight = Color(0xFF8B5FCF);
  static const Color deepPurpleDark = Color(0xFF4A2580);
  static const Color electricBlueLight = Color(0xFF4DD4F0);
  static const Color electricBlueDark = Color(0xFF0090AD);

  // Semantic Colors
  static const Color success = Color(0xFF28A745);
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFDC3545);
  static const Color errorLight = Color(0xFFF8D7DA);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color onWarning = Color(0xFF1A1A1A);

  static const Color info = Color(0xFF17A2B8);
  static const Color infoLight = Color(0xFFD1ECF1);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color surfaceDark = Color(0xFF1A1A2E);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepPurple, electricBlue],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldLight],
  );
}
