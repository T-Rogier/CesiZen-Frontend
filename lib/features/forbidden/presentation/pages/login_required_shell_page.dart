import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/shared/widgets/buttons/app_button.dart';

class LoginRequiredShellPage extends StatelessWidget {
  const LoginRequiredShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_open_outlined,
                  size: 80,
                  color: AppColors.yellowPrincipal,
                ),
                const SizedBox(height: 24),
                Text(
                  'Pour accéder à toutes les fonctionnalités, '
                      'veuillez vous connecter ou créer un compte.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Se connecter',
                  backgroundColor: AppColors.yellowPrincipal,
                  textColor: AppColors.black,
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text(
                    'Créer un compte',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.greenFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}