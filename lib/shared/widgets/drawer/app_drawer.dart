import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({super.key});

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
            ListTile(
              leading: const Icon(Icons.add, color: AppColors.greenFont),
              title: const Text('Créer une activité'),
              onTap: () {
                context.pop();
                context.push('/activity/create');
              },
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
            // … autres items de menu
          ],
        ),
      ),
    );
  }
}