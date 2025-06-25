import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import '../../domain/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onDisable;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onDisable,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Désactiver l\'utilisateur ?', style: AppTextStyles.title),
        content: Text(
          'Êtes‑vous sûr·e de vouloir désactivé "${user.username}" ?',
          style: AppTextStyles.caption,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppColors.black,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && onDisable != null) {
      onDisable!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: user.disabled
          ? AppColors.greenBackground.withOpacity(0.5)
          : AppColors.greenBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: user.disabled ? Colors.redAccent : AppColors.greenFill,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: user.disabled ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          user.username,
          style: AppTextStyles.title.copyWith(
            color: user.disabled ? Colors.grey : AppColors.black,
            decoration: user.disabled ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user.email,
              style: AppTextStyles.subtitle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              user.role,
              style: AppTextStyles.caption.copyWith(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: user.disabled
            ? null
            : IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _confirmDelete(context),
        )
      ),
    );
  }
}
