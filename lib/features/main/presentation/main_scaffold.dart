import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/main/presentation/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.greenFill,
        elevation: 0,
        title: Text(
          _getTitle(currentIndex),
          style: AppTextStyles.title,
        ),
        leading: Navigator.of(context).canPop()
            ? const BackButton(color: AppColors.black)
            : null,
      ),
      body: child,
      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/activities')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  String _getTitle(int index) {
    return switch (index) {
      0 => 'Accueil',
      1 => 'Rechercher',
      2 => 'Activités',
      3 => 'Profil',
      _ => '',
    };
  }
}
