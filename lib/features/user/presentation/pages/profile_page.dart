import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/features/forbidden/presentation/pages/login_required_shell_page.dart';
import 'package:cesizen_frontend/features/user/presentation/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authProvider).value!.session?.role;

    if (role == 'Admin') {
      return const UserProfilePage();
    }
    else if (role == 'User') {
      return const UserProfilePage();
    }
    else {
      return const LoginRequiredShellPage();
    }
  }
}
