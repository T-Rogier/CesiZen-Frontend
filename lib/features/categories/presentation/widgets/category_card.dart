import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/categories/domain/category.dart';

class CategoryCard extends StatelessWidget {

  final Category category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.onDelete,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la catégorie ?', style: AppTextStyles.title),
        content: Text('Êtes‑vous sûr·e de vouloir supprimer "${category.name}" ?', style: AppTextStyles.caption),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: AppColors.black),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && onDelete != null) {
      onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: category.deleted
          ? AppColors.greenBackground.withOpacity(0.5)
          : AppColors.greenBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: category.deleted ? Colors.redAccent : AppColors.greenFill,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: category.deleted ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            category.iconLink,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(Icons.category, size: 48),
          ),
        ),
        title: Text(
          category.name,
          style: AppTextStyles.title.copyWith(
            color: category.deleted ? Colors.grey : AppColors.black,
            decoration: category.deleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: category.deleted
            ? Text(
          'Supprimée',
          style: AppTextStyles.caption.copyWith(color: Colors.redAccent),
        )
            : null,
        trailing: category.deleted
            ? null
            : IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }
}
