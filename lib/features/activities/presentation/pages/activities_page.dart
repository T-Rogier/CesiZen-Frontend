import 'dart:async';

import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_provider.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/activity_card.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/filters_dropdown.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({super.key});

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  bool _showFilters = false;
  String searchQuery = '';
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 100) {
        ref.read(activityProvider.notifier).loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityProvider.notifier).loadMore();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    setState(() => searchQuery = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(activityProvider.notifier).searchActivities(query: searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(activityProvider);

    return Scaffold(
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
                    onChanged: _onSearchChanged,
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
            asyncState.when(
              loading: () => const Expanded(
                child: Center(child: Text('')),
              ),
              error: (e, _) => Expanded(child: Center(child: Text('Erreur : $e'))),
              data: (state) {
                return Column( children: [
                  if (_showFilters)
                    FiltersDropdown(
                      isVisible: _showFilters,
                      onToggle: () => setState(() => _showFilters = !_showFilters),
                      selectedType: state.selectedType,
                      startDuration: state.startDuration,
                      endDuration:   state.endDuration,
                      selectedCategories: state.selectedCategories,

                      onTypeChanged: (type) {
                        ref.read(activityProvider.notifier).searchActivities(
                          query: searchQuery,
                          type: type,
                          startDuration: state.startDuration,
                          endDuration: state.endDuration,
                          categories: state.selectedCategories,
                        );
                      },
                      onDurationChanged: (sd, ed) {
                        ref.read(activityProvider.notifier).searchActivities(
                          query: searchQuery,
                          type: state.selectedType,
                          startDuration: sd,
                          endDuration: ed,
                          categories: state.selectedCategories,
                        );
                      },
                      onCategoriesChanged: (cats) {
                        ref.read(activityProvider.notifier).searchActivities(
                          query: searchQuery,
                          type: state.selectedType,
                          startDuration: state.startDuration,
                          endDuration: state.endDuration,
                          categories: cats,
                        );
                      },
                    ),
                ],);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:   (e,_) => Center(child: Text('Erreur : $e')),
                data:    (state) {
                  if (state.activities.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucune activité trouvée',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollCtrl,
                    itemCount: state.activities.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i < state.activities.length) {
                        final act = state.activities[i];
                        return ActivityCard(
                          id: act.id,
                          title: act.title,
                          subtitle: act.estimatedDuration,
                          imageUrl: act.thumbnailImageLink,
                          participationCount: act.viewCount,
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
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
