import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/shared/widgets/buttons/app_button.dart';
import 'package:cesizen_frontend/shared/widgets/app_checkbox_label.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_password_input.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_text_input.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;

  Future<void> _register() async {
    if (!_acceptTerms) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    await ref.read(authProvider.notifier).register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      _confirmPasswordController.text,
    );
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
              Center(child: Text("Créer un compte", style: AppTextStyles.title)),
              const SizedBox(height: 32),

              AppTextInput(
                label: "Votre nom d'utilisateur",
                hint: "Entrez votre nom d'utilisateur",
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              AppTextInput(
                label: "Votre adresse email",
                hint: "Entrez votre adresse email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              AppPasswordInput(
                label: "Mot de passe",
                hint: "Entrez un mot de passe",
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              AppPasswordInput(
                label: "Confirmation du mot de passe",
                hint: "Confirmez votre mot de passe",
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 20),

              AppCheckboxLabel(
                value: _acceptTerms,
                onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                label: "J’accepte les conditions générales",
              ),
              const SizedBox(height: 24),

              AppButton(
                onPressed: (_acceptTerms && !auth.isLoading) ? _register : null,
                text: "S’inscrire",
                backgroundColor: AppColors.yellowPrincipal,
                textColor: AppColors.black,
                isLoading: auth.isLoading,
              ),

              if (auth.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Erreur d’inscription",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 40),

              Center(
                child: Column(
                  children: [
                    Text("Vous avez déjà un compte ?", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text(
                        "Connectez-vous",
                        style: TextStyle(
                          color: AppColors.greenFont,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
