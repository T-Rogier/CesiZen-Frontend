import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/features/forbidden/presentation/pages/login_required_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_home_page.dart';
import 'user_home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authProvider).value!.session?.role;

    if (role == 'Admin') {
      return const AdminHomePage();
    }
    else if (role == 'User') {
      return const UserHomePage();
    }
    else {
      return const LoginRequiredShellPage();
    }
  }
}
