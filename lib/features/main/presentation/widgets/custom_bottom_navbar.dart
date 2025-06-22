import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

import 'nav_icon.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenFill,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavIcon(route: '/home', index: 0, currentIndex: currentIndex, iconData: Icons.home, label: 'Accueil'),
          NavIcon(route: '/search', index: 1, currentIndex: currentIndex, iconData: Icons.search, label: 'Recherche'),
          NavIcon(route: '/activities', index: 2, currentIndex: currentIndex, assetPath: 'assets/icons/cesizen_icon.svg', label: 'Activités'),
          NavIcon(route: '/login', index: 3, currentIndex: currentIndex, iconData: Icons.person, label: 'Profil'),
        ],
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/activities')) return 2;
    if (location.startsWith('/login')) return 3;
    return 0;
  }
}
