import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/activity_card.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/filters_dropdown.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  bool _showFilters = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
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
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 14),
                IconButton(
                  onPressed: () => setState(() => _showFilters = !_showFilters),
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
              child: ListView(
                children: [
                  ActivityCard(
                    title: 'Comment surpasser ses émotions ?',
                    subtitle: 'Un petit cours du Dr Jean Roger',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 120,
                    onPressed: () => {},
                  ),
                  ActivityCard(
                    title: 'Alimentation consciente',
                    subtitle: 'Challenge de 7 jours',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 80,
                    onPressed: () => {},
                  ),
                  ActivityCard(
                    title: 'Yoga pour la concentration sur soi-même',
                    subtitle: 'Un petit cours du Dr Jean Roger',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 200,
                    onPressed: () => {},
                  ),
                  ActivityCard(
                    title: 'Yoga pour la concentration sur soi-même',
                    subtitle: 'Un petit cours du Dr Jean Roger',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 200,
                    onPressed: () => {},
                  ),
                  ActivityCard(
                    title: 'Yoga pour la concentration sur soi-même',
                    subtitle: 'Un petit cours du Dr Jean Roger',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 200,
                    onPressed: () => {},
                  ),
                  ActivityCard(
                    title: 'Yoga pour la concentration sur soi-même',
                    subtitle: 'Un petit cours du Dr Jean Roger',
                    imageUrl: 'https://picsum.photos/200',
                    participationCount: 200,
                    onPressed: () => {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
