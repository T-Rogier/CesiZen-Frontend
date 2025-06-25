import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final bool isEnabled;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      enabled: isEnabled,
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greenFont, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: isEnabled
                    ? AppColors.greenFill
                    : AppColors.greenFill.withOpacity(0.3),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
    style: AppTextStyles.body.copyWith(
    color: isEnabled ? AppColors.black : AppColors.black.withOpacity(0.5),
    ),
    validator: isEnabled ? validator : null,
    );
  }
}
