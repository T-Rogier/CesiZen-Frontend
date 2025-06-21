import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class ActivityCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int participationCount;

  const ActivityCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.participationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greenBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Zone texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline.copyWith(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.greenFont,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$participationCount participations',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/activity/$id');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                    ),
                    child: Text('Voir', style: AppTextStyles.button),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/exercices.png',
                image: imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/exercices.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
