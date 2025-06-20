import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final String value;
  final ValueChanged<String> onChanged;

  const AppSearchBar({
    super.key,
    required this.hintText,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hintText,
      leading: const Icon(Icons.search, color: AppColors.greenFont),
      elevation: const WidgetStatePropertyAll(1),
      backgroundColor: const WidgetStatePropertyAll(AppColors.greenFill),
      surfaceTintColor: const WidgetStatePropertyAll(AppColors.greenFill),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      constraints: const BoxConstraints(maxHeight: 50),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.greenFont,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
