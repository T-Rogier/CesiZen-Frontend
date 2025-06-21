import 'package:cesizen_frontend/features/activities/presentation/providers/activity_type_provider.dart';
import 'package:cesizen_frontend/features/categories/presentation/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/custom_filter_chip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_dropdown_filter.dart';

class FiltersDropdown extends ConsumerStatefulWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  final String? selectedType;
  final Duration? startDuration;
  final Duration? endDuration;
  final List<String> selectedCategories;

  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<List<String>> onCategoriesChanged;

  final void Function(Duration? start, Duration? end) onDurationChanged;

  const FiltersDropdown({
    super.key,
    required this.isVisible,
    required this.onToggle,
    required this.selectedCategories,
    this.selectedType,
    this.startDuration,
    this.endDuration,
    required this.onTypeChanged,
    required this.onCategoriesChanged,
    required this.onDurationChanged
  });

  @override
  ConsumerState<FiltersDropdown> createState() => _FiltersDropdownState();
}

class _FiltersDropdownState extends ConsumerState<FiltersDropdown> {
  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(categoriesProvider);
    final typesAsync = ref.watch(activityTypesProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              typesAsync.when(
                loading: () => const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(),
                ),
                error: (e, _) => Text('Erreur types : $e'),
                data: (types) {
                  final items = <DropdownFilterItem<String>>[
                    DropdownFilterItem(value: 'all', label: 'Tout'),
                    ...types.map((t) => DropdownFilterItem(value: t, label: t)),
                  ];
                  return CustomDropdownFilter<String>(
                    label: 'Type d’activité',
                    value: widget.selectedType,
                    items: items,
                    onChanged: widget.onTypeChanged,
                  );
                },
              ),
              CustomDropdownFilter<String>(
                label: 'Durée estimée',
                value: () {
                  final sd = widget.startDuration;
                  final ed = widget.endDuration;
                  if (sd == null && ed == null) return 'any';
                  if (sd == Duration.zero && ed == Duration(minutes:10)) return 'short';
                  if (sd == Duration(minutes:10) && ed == Duration(minutes:30)) return 'medium';
                  if (sd == Duration(minutes:30) && ed == null) return 'long';
                  return 'custom';
                }(),
                items: [
                  DropdownFilterItem(value: 'any',    label: 'Toute durée', icon: Icons.timer),
                  DropdownFilterItem(value: 'short',  label: '< 10 min',    icon: Icons.timer),
                  DropdownFilterItem(value: 'medium', label: '10–30 min',     icon: Icons.timer_outlined),
                  DropdownFilterItem(value: 'long',   label: '> 30 min',     icon: Icons.timer_sharp),
                  DropdownFilterItem(value: 'custom', label: 'Personnalisée', icon: Icons.schedule),
                ],
                onChanged: (val) async {
                  Duration? sd;
                  Duration? ed;
                  switch (val) {
                    case 'any':
                      break;
                    case 'short':
                      sd = Duration.zero;
                      ed = Duration(minutes: 10);
                      break;
                    case 'medium':
                      sd = Duration(minutes: 10);
                      ed = Duration(minutes: 30);
                      break;
                    case 'long':
                      sd = Duration(minutes: 30);
                      ed = null;
                      break;
                    case 'custom':
                      final startTd = await showTimePicker(
                        context: context,
                        initialTime: widget.startDuration != null
                            ? TimeOfDay(
                            hour: widget.startDuration!.inHours,
                            minute: widget.startDuration!.inMinutes % 60)
                            : const TimeOfDay(hour: 0, minute: 0),
                      );
                      if (startTd == null) return;
                      final endTd = await showTimePicker(
                        context: context,
                        initialTime: widget.endDuration != null
                            ? TimeOfDay(
                            hour: widget.endDuration!.inHours,
                            minute: widget.endDuration!.inMinutes % 60)
                            : const TimeOfDay(hour: 0, minute: 0),
                      );
                      if (endTd == null) return;
                      sd = Duration(hours: startTd.hour, minutes: startTd.minute);
                      ed = Duration(hours: endTd.hour,   minutes: endTd.minute);
                      break;
                  }
                  widget.onDurationChanged(sd, ed);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          catsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Erreur catégories : $e'),
            data: (allCategories) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allCategories.map((cat) {
                final selected = widget
                    .selectedCategories
                    .contains(cat.name);
                return CustomFilterChip(
                  label: cat.name,
                  selected: selected,
                  onSelected: (yes) {
                    final newCats = List<String>.from(
                      widget.selectedCategories,
                    );
                    if (yes) {
                      newCats.add(cat.name);
                    } else {
                      newCats.remove(cat.name);
                    }
                    widget.onCategoriesChanged(newCats);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      )
    );
  }
}
