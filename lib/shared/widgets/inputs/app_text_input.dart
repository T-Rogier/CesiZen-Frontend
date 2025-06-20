import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppTextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const AppTextInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greenFill,
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.greenFont),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}