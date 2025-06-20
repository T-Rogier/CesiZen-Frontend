import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppCheckboxLabel extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const AppCheckboxLabel({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.greenFont,
        ),
        Text(label, style: AppTextStyles.subtitle),
      ],
    );
  }
}
