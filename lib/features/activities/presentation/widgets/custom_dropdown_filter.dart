import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownFilter<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownFilterItem<T>> items;
  final ValueChanged<T?> onChanged;

  const CustomDropdownFilter({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: value,
      onSelected: onChanged,
      menuHeight: 180,
      width: MediaQuery.of(context).size.width * 0.45,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AppColors.greenFont),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AppColors.greenFont),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: BoxConstraints(maxHeight: 38),
      ),
      dropdownMenuEntries: items.map((item) {
        return DropdownMenuEntry<T>(
          value: item.value,
          label: item.label,
          leadingIcon: item.icon != null ? Icon(item.icon, color: AppColors.greenFont) : null,
        );
      }).toList(),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.greenFont),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.greenFill),
        elevation: const WidgetStatePropertyAll(4),
      ),
    );
  }
}

class DropdownFilterItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  DropdownFilterItem({
    required this.value,
    required this.label,
    this.icon,
  });
}