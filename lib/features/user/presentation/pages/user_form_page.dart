import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/user/domain/user_create_request.dart';
import 'package:cesizen_frontend/features/user/domain/user.dart';
import 'package:cesizen_frontend/features/user/domain/user_update_request.dart';
import 'package:cesizen_frontend/features/user/presentation/providers/user_provider.dart';
import 'package:cesizen_frontend/shared/widgets/buttons/app_button.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_password_input.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserFormPage extends ConsumerWidget {
  final String? userId;
  const UserFormPage({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = userId != null
        ? ref.watch(userByIdProvider(userId!))
        : AsyncValue.data(null);

    return asyncUser.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e,_) => Scaffold(
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (existing) {
        return _UserFormBody(
          user: existing,
        );
      },
    );
  }
}

class _UserFormBody extends ConsumerStatefulWidget {
  final User? user;
  const _UserFormBody({this.user});

  @override
  _UserFormBodyState createState() => _UserFormBodyState();
}

class _UserFormBodyState extends ConsumerState<_UserFormBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  bool _isSubmitting = false;
  String? _role;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController(text: '');
    _confirmController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final createRequest = UserCreateRequest(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
      role: _role!,
    );

    final updateRequest = UserUpdateRequest(
      username: _usernameController.text,
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
      role: _role!,
    );

    try {
      final notifier = ref.read(formUserProvider);
      if (widget.user == null) {
        await notifier.createUser(createRequest);
      } else {
        await notifier.updateUser(widget.user!.id, updateRequest);
      }

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur créé avec succès')),
        );
        context.pop();
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
    finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(userRolesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.greenFont,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'Créer un utilisateur',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        child: rolesAsync.when(
          data: (roles) {
            _role ??= roles.isNotEmpty ? roles.first : null;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Information utilisateur',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    labelText: "Nom d'utilisateur",
                    controller: _usernameController,
                    validator: (v) => v?.isEmpty ?? true ? 'Veuillez entrer un nom d\'utilisateur' : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    labelText: 'Adresse email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Veuillez entrer une adresse email';
                      if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v)) return 'Email invalide';
                      return null;
                    },
                    isEnabled: widget.user == null,
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Sécurité',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 8),
                  AppPasswordInput(
                    label: "Mot de passe",
                    hint: "Mot de passe",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordInput(
                    label: "Confirmation du mot de passe",
                    hint: "Confirmer mot de passe",
                    controller: _confirmController,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _role,
                    decoration: InputDecoration(
                      hintText: 'Sélectionnez un rôle',
                    ),
                    style: AppTextStyles.body,
                    items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (v) => setState(() => _role = v),
                    validator: (v) => v == null ? 'Sélection obligatoire' : null,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    onPressed: _isSubmitting ? null : _submit,
                    text: widget.user == null ? 'Créer' : 'Enregister',
                    backgroundColor: AppColors.yellowPrincipal,
                    textColor: AppColors.black,
                    isLoading: _isSubmitting,
                  )
                ],
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.greenFont)),
          error: (e, _) => Center(child: Text('Erreur chargement rôles: $e', style: AppTextStyles.body)),
        ),
      ),
    );
  }
}