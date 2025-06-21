import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnboardingPage extends StatelessWidget {
  const UnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              const SizedBox(height: 24),

              // Titre principal
              Text(
                "L’application de votre santé mentale",
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.yellowPrincipal,
                ),
              ),
              const SizedBox(height: 12),

              // Sous-titre
              Text(
                "Des exercices de respiration, de méditation\net de visualisation pour vous aider à mieux\ngérer le stress.",
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),

              const Spacer(flex: 3),

              // Bouton S'inscrire
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenFont,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("S'inscrire", style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 16),

              // Bouton Se connecter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Se connecter", style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 16),

              // Bouton Passer cette étape
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: accès direct sans connexion
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenFill,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Passer cette étape",
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Text(
                "En continuant, vous acceptez les Conditions d'utilisation.\nLisez notre Politique de confidentialité.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greenFont,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
