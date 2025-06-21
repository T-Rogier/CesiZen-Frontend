import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/welcome_card.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Bienvenue sur CesiZen',
                style: AppTextStyles.headline
              ),
              const SizedBox(height: 12),
              const Text(
                'Faites une pause. Ralentissez. Respirez.\nProfitez de notre bibliothèque de contenu pour vous aider à trouver l\'équilibre.',
                style: AppTextStyles.subtitle
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    WelcomeCard(
                      title: 'Exercices',
                      subtitle: 'Trouvez la paix intérieure avec nos méditations guidées',
                      imagePath: 'assets/images/exercices.png',
                    ),
                    WelcomeCard(
                      title: 'Ecriture',
                      subtitle: 'Libérez vos pensées avec nos exercices d\'écriture',
                      imagePath: 'assets/images/ecriture.png',
                    ),
                    WelcomeCard(
                      title: 'Musique',
                      subtitle: 'Trouvez des chansons et listes de lecture pour vous détendre',
                      imagePath: 'assets/images/musique.png',
                    ),
                    WelcomeCard(
                      title: 'Puzzle',
                      subtitle: 'Complétez des puzzles pour vous détendre',
                      imagePath: 'assets/images/puzzle.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowPrincipal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Commencer',
                    style: AppTextStyles.button
                  ),
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