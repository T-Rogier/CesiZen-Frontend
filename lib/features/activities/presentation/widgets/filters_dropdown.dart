import 'package:flutter/material.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/custom_filter_chip.dart';
import 'custom_dropdown_filter.dart';

class FiltersDropdown extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  const FiltersDropdown({
    super.key,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  State<FiltersDropdown> createState() => _FiltersDropdownState();
}

class _FiltersDropdownState extends State<FiltersDropdown> {
  final Map<String, bool> _filters = {
    'Méditation': false,
    'Sommeil': false,
    'Sport': false,
    'Focus': false,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdownFilter<String>(
                label: 'Type d’activité',
                value: 'all',
                onChanged: (val) {},
                items: [
                  DropdownFilterItem(
                      value: 'all', label: 'Tout', icon: Icons.list),
                  DropdownFilterItem(value: 'meditation',
                      label: 'Méditation',
                      icon: Icons.self_improvement),
                ],
              ),
              CustomDropdownFilter<String>(
                label: 'Durée estimée',
                value: 'any',
                onChanged: (val) {},
                items: [
                  DropdownFilterItem(
                      value: 'short', label: '< 10 min', icon: Icons.timer),
                  DropdownFilterItem(value: 'medium',
                      label: '10–30 min',
                      icon: Icons.timer_outlined),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filters.entries.map((entry) {
              return CustomFilterChip(
                label: entry.key,
                selected: entry.value,
                onSelected: (bool selected) {
                  setState(() {
                    _filters[entry.key] = selected;
                  });
                },
              );
            }).toList(),
          )
        ],
      )
    );
  }
}
