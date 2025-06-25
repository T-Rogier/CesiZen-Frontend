import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAdminDrawer extends StatelessWidget {
  const AppAdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.greenFill),
              child: Text('Administration', style: TextStyle(fontSize: 24, color: AppColors.greenFont)),
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Activités', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: AppColors.greenFont),
                  title: const Text('Créer une activité'),
                  onTap: () {
                    context.pop();
                    context.push('/activity/create');
                  },
                ),
                ListTile(
                  title: const Text('Catégories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                ListTile(
                  leading: const Icon(Icons.category, color: AppColors.greenFont),
                  title: const Text('Lister les catégories'),
                  onTap: () {
                    context.pop();
                    context.push('/categories');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: AppColors.greenFont),
                  title: const Text('Créer une catégorie'),
                  onTap: () {
                    context.pop();
                    context.push('/category/create');
                  },
                ),
                ListTile(
                  title: const Text('Utilisateurs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user, color: AppColors.greenFont),
                  title: const Text('Lister les utilisateurs'),
                  onTap: () {
                    context.pop();
                    context.push('/users');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: AppColors.greenFont),
                  title: const Text('Créer un utilisateur'),
                  onTap: () {
                    context.pop();
                    context.push('/user/create');
                  },
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}