import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequireRole extends ConsumerWidget {
  final List<String> allowedRoles;
  final Widget child;

  const RequireRole({
    super.key,
    required this.allowedRoles,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final role = auth?.session?.role;

    if (role == null || !allowedRoles.contains(role)) {
      return const SizedBox.shrink(); // rien du tout
    }
    return child;
  }
}