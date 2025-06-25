import 'package:cesizen_frontend/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(myProfileProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (session) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.greenFill,
                  child: Text(
                    session.username.isNotEmpty
                        ? session.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(session.username, style: AppTextStyles.headline),
                const SizedBox(height: 8),
                Text(session.email, style: AppTextStyles.subtitle),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Se déconnecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowPrincipal,
                    foregroundColor: AppColors.black,
                  ),
                  onPressed: () async {
                    context.go('/unboarding');
                    await ref.read(authProvider.notifier).logout();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Supprimer mon compte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: AppColors.black
                  ),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Supprimer mon compte'),
                        content: const Text('Cette action est irréversible.\nContinuer ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Annuler'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: AppColors.black
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref.read(authProvider.notifier).deleteAccount();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
