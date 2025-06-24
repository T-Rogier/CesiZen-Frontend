import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Accès refusé',
          style: AppTextStyles.headline.copyWith(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Oups !\nVous n’êtes pas autorisé·e à accéder à cette page.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour à l’accueil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenFill,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}