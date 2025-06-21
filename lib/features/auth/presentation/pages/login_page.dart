import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/shared/widgets/buttons/app_button.dart';
import 'package:cesizen_frontend/shared/widgets/app_checkbox_label.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_password_input.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_text_input.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  Future<void> _login() async {
    debugPrint('[LOGIN PAGE] Bouton cliqué');
    final email = _emailController.text;
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Me connecter", style: AppTextStyles.headline),
              ),
              const SizedBox(height: 32),

              AppTextInput(
                label: "Votre adresse courriel",
                hint: "Entrez votre adresse courriel",
                controller: _emailController,
              ),
              const SizedBox(height: 24),

              AppPasswordInput(
                label: "Mot de passe",
                hint: "Entrez votre mot de passe",
                controller: _passwordController,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(color: AppColors.greenFont),
                  ),
                ),
              ),

              AppCheckboxLabel(
                value: _rememberMe,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                label: "Se souvenir de moi",
              ),
              const SizedBox(height: 24),

              AppButton(
                onPressed: auth.isLoading ? null : _login,
                text: "Se connecter",
                backgroundColor: AppColors.yellowPrincipal,
                textColor: AppColors.black,
                isLoading: auth.isLoading,
              ),

              if (auth.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Erreur de connexion",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 48),

              Center(
                child: Column(
                  children: [
                    Text("Vous n'avez pas de compte ?", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: Text(
                        "Inscrivez-vous pour en obtenir un dès maintenant",
                        style: TextStyle(
                          color: AppColors.greenFont,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/home'),
                      child: const Text('Voir Debug'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
