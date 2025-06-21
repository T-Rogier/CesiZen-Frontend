import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_provider.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/activity_card.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/filters_dropdown.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({super.key});

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  bool _showFilters = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(activityProvider);

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: AppColors.greenFill),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.greenFont,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add, color: AppColors.greenFont),
                title: const Text('Créer une activité'),
                onTap: () {
                  // ferme le drawer
                  Navigator.of(context).pop();
                  // navigue vers la page de création
                  context.push('/activity/create');
                  // ou : Navigator.of(context).push(
                  //  MaterialPageRoute(builder: (_) => const ActivityCreatePage())
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: AppColors.greenFont),
                title: const Text('Créer une catégorie'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/category/create');
                },
              ),
              // ajoute autant de ListTile que nécessaire…
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppSearchBar(
                    hintText: 'Rechercher une activité...',
                    value: searchQuery,
                    onChanged: (val) {
                      debugPrint('✏️ AppSearchBar.onChanged: $val');
                      setState(() => searchQuery = val);
                      // Lancer la recherche à chaque changement (ou
                      // tu peux plutôt faire sur onSubmitted si tu préfères)
                      ref
                          .read(activityProvider.notifier)
                          .searchActivities(query: searchQuery);
                    },
                  ),
                ),
                const SizedBox(width: 14),
                IconButton(
                  onPressed: () =>
                      setState(() => _showFilters = !_showFilters),
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColors.greenFont,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.greenFill,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.greenFont),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_showFilters)
              FiltersDropdown(
                isVisible: _showFilters,
                onToggle: () => setState(() => _showFilters = !_showFilters),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Center(child: Text('Erreur: $err')),
                data: (state) {
                  final list = state.activities;
                  if (list.isEmpty) {
                    return const Center(child: Text('Aucune activité trouvée'));
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final act = list[i];
                      return ActivityCard(
                        id: act.id,
                        title: act.title,
                        subtitle: act.estimatedDuration,
                        imageUrl: act.thumbnailImageLink,
                        participationCount: act.viewCount,
                      );
                    },
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
