import 'package:flutter/material.dart';

class AppColors {
  static const greenFill = Color(0xFFE5F5ED);
  static const yellowPrincipal = Color(0xFFFFDE59);
  static const greenBackground = Color(0xFFF7FCFA);
  static const greenFont = Color(0xFF45A173);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF0D1C14);
  static const greenActiveFill = Color(0xFFD6F9E8);
}

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      fontFamily: 'Epilogue',
      primaryColor: AppColors.greenFont,
      scaffoldBackgroundColor: AppColors.greenBackground,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.greenFont,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.black,
        ),
      ),
      // etc.
    );
  }
}