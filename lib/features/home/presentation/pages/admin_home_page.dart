import 'package:cesizen_frontend/features/activities/presentation/providers/my_activity_provider.dart';
import 'package:cesizen_frontend/features/home/presentation/widgets/activity_preview_card.dart';
import 'package:cesizen_frontend/features/home/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const utilisateurConnecte = 50;
    const participations = 130;
    const activiteCrees = 5;

    final myActAsync = ref.watch(myActivitiesProvider);

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
                    label: 'Utilisateurs connectés',
                    value: utilisateurConnecte.toString(),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: StatCard(
                    label: 'Activités créées',
                    value: activiteCrees.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCard(
              label: 'Participations sur une activité',
              value: participations.toString(),
            ),
            const SizedBox(height: 24),

            // Favoris
            Text(
              'Vos activités crées',
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            myActAsync.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Erreur activités créées : $e'),
              ),
              data: (paged) {
                final list = paged.items;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Aucune activité créée',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 190,
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