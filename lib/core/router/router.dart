import 'package:cesizen_frontend/features/auth/presentation/providers/go_router_refresh_notifier.dart';
import 'package:cesizen_frontend/features/debug/presentation/pages/debug_page.dart';
import 'package:cesizen_frontend/features/main/presentation/main_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';

import 'package:cesizen_frontend/features/unboarding/presentation/pages/welcome_page.dart';
import 'package:cesizen_frontend/features/unboarding/presentation/pages/unboarding_page.dart';
import 'package:cesizen_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:cesizen_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:cesizen_frontend/features/home/presentation/pages/home_page.dart';
import 'package:cesizen_frontend/features/search/presentation/pages/search_page.dart';
import 'package:cesizen_frontend/features/activities/presentation/pages/activities_page.dart';
import 'package:cesizen_frontend/features/profile/presentation/pages/profile_page.dart';

final goRouterRefreshProvider = Provider<GoRouterRefreshNotifier>(
      (ref) => GoRouterRefreshNotifier(ref),
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: ref.watch(goRouterRefreshProvider),

    redirect: (context, state) {
      final auth = ref.read(authProvider);

      final isLoggedIn = auth.value?.status == AuthStatus.authenticated &&
          auth.value?.isTokenValid == true;
      final isLoading = auth.isLoading;
      final location = state.matchedLocation;

      final publicRoutes = {
        '/login',
        '/register',
        '/welcome',
        '/unboarding',
        '/debug',
        '/home',
        '/search',
        '/activities',
        '/profile',
      };

      if (isLoading) return null;

      final isPublic = publicRoutes.contains(location);

      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && location == '/login') return '/home';

      return null;
    },

    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
          GoRoute(path: '/activities', builder: (context, state) => const ActivitiesPage()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
        ],
      ),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomePage()),
      GoRoute(path: '/unboarding', builder: (_, _) => const UnboardingPage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      GoRoute(path: '/debug', builder: (_, _) => const DebugPage()),
    ],
  );
});

