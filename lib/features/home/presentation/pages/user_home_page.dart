import 'package:cesizen_frontend/features/activities/presentation/providers/activity_by_state_provider.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_favorite_provider.dart';
import 'package:cesizen_frontend/features/home/presentation/widgets/activity_preview_card.dart';
import 'package:cesizen_frontend/features/home/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

class UserHomePage extends ConsumerWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const joursActifs = 7;
    const nouvellesActivites = 3;
    const activitesCompletees = 5;

    final favAsync = ref.watch(favoriteActivitiesProvider);
    final inProgressAsync = ref.watch(activitiesByStateProvider('En cours'));
    final completedAsync  = ref.watch(activitiesByStateProvider('Terminé'));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistiques
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Jours actifs',
                    value: joursActifs.toString(),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: StatCard(
                    label: 'Nouvelles activités',
                    value: nouvellesActivites.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCard(
              label: 'Activités complétées',
              value: activitesCompletees.toString(),
            ),
            const SizedBox(height: 24),

            // Favoris
            Text(
              'Vos activités favorites',
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            favAsync.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Erreur favoris : $e'),
              ),
              data: (paged) {
                final list = paged.items;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Aucune activité favorite',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return Padding(
                        padding: EdgeInsets.only(right: 12, bottom: 8),
                        child: ActivityPreviewCard(activity: a),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // En cours
            Text(
              'Vos activités en cours',
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            inProgressAsync.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Erreur cours : $e'),
              ),
              data: (paged) {
                final list = paged.items;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Aucune activité en cours',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return Padding(
                        padding: EdgeInsets.only(right: 12, bottom: 8),
                        child: ActivityPreviewCard(activity: a),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // En cours
            Text(
              'Vos activités terminées',
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            completedAsync.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Erreur cours : $e'),
              ),
              data: (paged) {
                final list = paged.items;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Aucune activité terminée',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return Padding(
                        padding: EdgeInsets.only(right: 12, bottom: 8),
                        child: ActivityPreviewCard(activity: a),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}