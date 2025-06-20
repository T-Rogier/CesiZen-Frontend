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
      useMaterial3: true,
      fontFamily: 'Epilogue',
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Epilogue'),

      primaryColor: AppColors.greenFont,
      scaffoldBackgroundColor: AppColors.white,
      splashColor: AppColors.greenFont.withOpacity(0.1),
      highlightColor: Colors.transparent,
      focusColor: AppColors.greenFont,

      colorScheme: const ColorScheme.light(
        primary: AppColors.greenFont,
        secondary: AppColors.greenFill,
        surfaceContainer: AppColors.greenBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.black,
        surface: AppColors.white,
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.greenFont,
        selectionColor: AppColors.greenFill,
        selectionHandleColor: AppColors.greenFont,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greenFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.greenFont),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.white),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }
}

