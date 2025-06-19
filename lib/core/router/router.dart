import 'package:cesizen_frontend/features/unboarding/presentation/pages/unboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/activities/presentation/pages/activities_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../presentation/providers/auth_provider.dart';

GoRouter goRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/unboarding',
    refreshListenable: Provider.of<AuthProvider>(context, listen: false),
    redirect: (context, state) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = auth.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/unboarding';

      if (!isLoggedIn && !isLoggingIn && !isOnboarding) return '/login';
      if (isLoggedIn && (isLoggingIn || isOnboarding)) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/unboarding',
        builder: (context, state) => const UnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/activities',
        builder: (context, state) => const ActivitiesPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
