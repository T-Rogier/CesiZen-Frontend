import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ActivityDetailPage extends ConsumerWidget {
  final String activityId;
  const ActivityDetailPage({super.key, required this.activityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAct = ref.watch(activityDetailProvider(activityId));

    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CloseButton(color: AppColors.greenFont),
      ),
      body: asyncAct.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (act) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image en haut full width
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    act.thumbnailImageLink,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Titre
                Text(
                  act.title,
                  style: AppTextStyles.headline.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  act.description,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.timer, size: 20, color: AppColors.greenFont),
                    const SizedBox(width: 4),
                    Text(act.estimatedDuration, style: AppTextStyles.caption),
                    const SizedBox(width: 16),
                    Icon(Icons.visibility, size: 20, color: AppColors.greenFont),
                    const SizedBox(width: 4),
                    Text('${act.viewCount} vues', style: AppTextStyles.caption),
                    const SizedBox(width: 16),
                    Chip(
                      label: Text(act.type, style: AppTextStyles.caption),
                      backgroundColor: AppColors.greenActiveFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.greenFont,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: act.categories.map((cat) {
                    return Chip(
                      label: Text(cat, style: AppTextStyles.caption),
                      backgroundColor: AppColors.greenActiveFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.greenFont,
                          width: 1.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: démarrer l'activité
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowPrincipal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Commencer',
                            style: AppTextStyles.button.copyWith(
                                color: AppColors.black)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: ajouter aux favoris
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenFill.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          act.isFavoris ?? false ? 'En favoris' : 'Ajouter aux favoris',
                          style:
                          AppTextStyles.button.copyWith(color: AppColors.greenFont),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Progression
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Progression :', style: AppTextStyles.body),
                    const SizedBox(width: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: act.progress,
                            strokeWidth: 6,
                            backgroundColor: AppColors.greenFill.withOpacity(0.1),
                          ),
                        ),
                        Text('${(act.progress ?? 0 * 100).round()}%',
                            style: AppTextStyles.body),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        }
      ),
    );
  }
}
