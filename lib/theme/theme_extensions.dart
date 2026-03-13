import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textStyles => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  Brightness get brightness => theme.brightness;
}

extension ColorSchemeExtensions on ColorScheme {
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;
}
