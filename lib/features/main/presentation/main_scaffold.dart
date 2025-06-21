import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/main/presentation/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final Widget? drawer;

  const MainScaffold({super.key, required this.child, this.drawer,});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateIndex(location);
    final canPop = context.canPop();

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.greenFill,
        elevation: 0,
        title: Text(
          _getTitle(currentIndex),
          style: AppTextStyles.headline,
        ),
        leading: drawer != null
            ?
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.black),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        )
            : canPop
            ? const BackButton(color: AppColors.black)
            : null,
      ),
      body: child,
      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }

  int _calculateIndex(String location) {
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
