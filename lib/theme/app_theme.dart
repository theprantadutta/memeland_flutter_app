import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.deepPurple,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.deepPurpleLight.withValues(alpha: 0.2),
      onPrimaryContainer: AppColors.deepPurpleDark,
      secondary: AppColors.gold,
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.goldLight.withValues(alpha: 0.3),
      onSecondaryContainer: AppColors.goldDark,
      tertiary: AppColors.electricBlue,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.electricBlueLight.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.electricBlueDark,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.white,
      onSurface: AppColors.grey900,
      surfaceContainerHighest: AppColors.surfaceLight,
      onSurfaceVariant: AppColors.grey600,
      outline: AppColors.grey400,
      outlineVariant: AppColors.grey300,
      shadow: AppColors.grey900.withValues(alpha: 0.1),
      scrim: AppColors.black.withValues(alpha: 0.3),
      inverseSurface: AppColors.grey900,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.deepPurpleLight,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.deepPurpleLight,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.deepPurpleDark,
      onPrimaryContainer: AppColors.deepPurpleLight,
      secondary: AppColors.gold,
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.goldDark.withValues(alpha: 0.3),
      onSecondaryContainer: AppColors.goldLight,
      tertiary: AppColors.electricBlueLight,
      onTertiary: AppColors.black,
      tertiaryContainer: AppColors.electricBlueDark,
      onTertiaryContainer: AppColors.electricBlueLight,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.error.withValues(alpha: 0.2),
      onErrorContainer: AppColors.errorLight,
      surface: const Color(0xFF1E1E2E),
      onSurface: AppColors.grey100,
      surfaceContainerHighest: AppColors.surfaceDark,
      onSurfaceVariant: AppColors.grey400,
      outline: AppColors.grey600,
      outlineVariant: AppColors.grey700,
      shadow: AppColors.black.withValues(alpha: 0.3),
      scrim: AppColors.black.withValues(alpha: 0.5),
      inverseSurface: AppColors.grey100,
      onInverseSurface: AppColors.grey900,
      inversePrimary: AppColors.deepPurple,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: AppTypography.applyColor(textTheme, colorScheme.onSurface),
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          minimumSize: const Size(0, AppSizing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          minimumSize: const Size(0, AppSizing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          textStyle: textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colorScheme.surface : AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.dialog)),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.grey800 : AppColors.grey900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primary.withValues(alpha: 0.2),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
