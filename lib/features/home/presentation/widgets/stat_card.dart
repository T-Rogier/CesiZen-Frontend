import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isWide;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greenFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenFont),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                value,
                style: AppTextStyles.headline.copyWith(fontSize: 32),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.greenFont))),
          ],
        ),
      ),
    );
  }
}