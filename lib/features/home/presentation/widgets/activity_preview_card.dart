import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/domain/activity.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_by_state_provider.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityPreviewCard extends ConsumerWidget {
  final Activity activity;
  const ActivityPreviewCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push('/activity/${activity.id}').then((_) {
          ref.invalidate(favoriteActivitiesProvider);
          ref.invalidate(activitiesByStateProvider('InProgress'));
          ref.invalidate(activitiesByStateProvider('Completed'));
        });
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: AppColors.greenBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.network(
                  activity.thumbnailImageLink,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                activity.title,
                style: AppTextStyles.title.copyWith(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
