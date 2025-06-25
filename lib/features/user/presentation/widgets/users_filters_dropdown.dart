import 'package:cesizen_frontend/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_users_dropdown_filter.dart';

class UsersFiltersDropdown extends ConsumerStatefulWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  final String? selectedRole;
  final bool? disabled;

  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<bool?> onDisabledChanged;

  const UsersFiltersDropdown({
    super.key,
    required this.isVisible,
    required this.onToggle,
    this.selectedRole,
    this.disabled,
    required this.onRoleChanged,
    required this.onDisabledChanged,
  });

  @override
  ConsumerState<UsersFiltersDropdown> createState() => _FiltersDropdownState();
}

class _FiltersDropdownState extends ConsumerState<UsersFiltersDropdown> {
  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(userRolesProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rolesAsync.when(
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
                  return CustomUsersDropdownFilter<String>(
                    label: 'Rôle utilisateur',
                    value: widget.selectedRole,
                    items: items,
                    onChanged: widget.onRoleChanged,
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomUsersDropdownFilter<bool?>(
                label: 'Désactivé',
                value: widget.disabled,
                items: [
                  DropdownFilterItem(value: null,    label: 'Tout'),
                  DropdownFilterItem(value: true,    label: 'Activé'),
                  DropdownFilterItem(value: false,  label: 'Désactivé'),
                ],
                onChanged: widget.onDisabledChanged,
              )
            ],
          ),

        ],
      )
    );
  }
}
