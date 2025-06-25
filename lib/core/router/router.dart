import 'package:cesizen_frontend/core/router/routes.dart';
import 'package:cesizen_frontend/features/articles/presentation/pages/article_detail_page.dart';
import 'package:cesizen_frontend/features/articles/presentation/widgets/menu_drawer.dart';
import 'package:cesizen_frontend/features/articles/presentation/pages/articles_page.dart';
import 'package:cesizen_frontend/features/activities/presentation/pages/activity_create_page.dart';
import 'package:cesizen_frontend/features/activities/presentation/pages/activity_detail_page.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/go_router_refresh_notifier.dart';
import 'package:cesizen_frontend/features/categories/presentation/pages/categories_page.dart';
import 'package:cesizen_frontend/features/categories/presentation/pages/category_form_page.dart';
import 'package:cesizen_frontend/features/debug/presentation/pages/debug_page.dart';
import 'package:cesizen_frontend/features/forbidden/presentation/pages/forbidden_page.dart';
import 'package:cesizen_frontend/features/forbidden/presentation/pages/login_required_page.dart';
import 'package:cesizen_frontend/features/main/presentation/main_scaffold.dart';
import 'package:cesizen_frontend/features/user/presentation/pages/profile_page.dart';
import 'package:cesizen_frontend/shared/widgets/drawer/app_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';

import 'package:cesizen_frontend/features/unboarding/presentation/pages/welcome_page.dart';
import 'package:cesizen_frontend/features/unboarding/presentation/pages/unboarding_page.dart';
import 'package:cesizen_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:cesizen_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:cesizen_frontend/features/home/presentation/pages/home_page.dart';
import 'package:cesizen_frontend/features/activities/presentation/pages/activities_page.dart';

final goRouterRefreshProvider = Provider<GoRouterRefreshNotifier>(
      (ref) => GoRouterRefreshNotifier(ref),
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: ref.watch(goRouterRefreshProvider),
    redirect: (context, state) {
      final auth       = ref.read(authProvider);
      final isLoading  = auth.isLoading;
      final session    = auth.value?.session;
      final isLoggedIn = auth.value?.status == AuthStatus.authenticated;
      final location   = state.matchedLocation;

      if (isLoading) {
        return null;
      }

      if (publicRoutes.contains(location)) {
        if (isLoggedIn && (location == '/login' || location == '/register')) {
          return '/home';
        }
        return null;
      }

      if (!isLoggedIn) {
        return '/login-required';
      }

      final role = session!.role;
      final allowed = roleAllowed[role]!;

      if (allowed.contains(location)) {
        return null;
      }

      final uri      = Uri.parse(location);
      final segments = uri.pathSegments;
      if (segments.length == 2) {
        final base = '/${segments[0]}';
        final id   = segments[1];
        final isNum = int.tryParse(id) != null;
        if (isNum && allowed.contains(base)) {
          return null;
        }
      }
      return '/forbidden';
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final location = GoRouterState.of(context).uri.toString();

          final onActivities = location.startsWith('/activities');
          final onArticles   = location.startsWith('/articles');

          return Consumer(
            builder: (context, ref, _) {
              final authState = ref.watch(authProvider).value;
              final role = authState?.session?.role;
              final showActivitiesDrawer = onActivities && role == 'Admin';

              final showArticlesDrawer = onArticles;

              final drawer = showActivitiesDrawer
                  ? const MyAppDrawer()
                  : showArticlesDrawer
                  ? const MenuDrawer()
                  : null;

              return MainScaffold(
                drawer: drawer,
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(path: '/articles', builder: (context, state) => const ArticlesPage()),
          GoRoute(path: '/activities', builder: (context, state) => const ActivitiesPage()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
        ],
      ),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomePage()),
      GoRoute(path: '/unboarding', builder: (_, _) => const UnboardingPage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      GoRoute(path: '/activity/create', builder: (_, _) => const ActivityCreatePage()),
      GoRoute(
        path: '/activity/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ActivityDetailPage(activityId: id);
        },
      ),
      GoRoute(path: '/categories', builder: (_, _) => const CategoriesPage()),
      GoRoute(path: '/category/create', builder: (_, _) => const CategoryFormPage()),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CategoryFormPage(categoryId: id);
        },
      ),
      GoRoute(
        path: '/article/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ArticleDetailPage(articleId: id);
        },
      ),
      GoRoute(path: '/debug', builder: (_, _) => const DebugPage()),
      GoRoute(path: '/forbidden', builder: (_,_) => const ForbiddenPage()),
      GoRoute(path: '/login-required', builder: (_,_) => const LoginRequiredPage()),
    ],
  );
});


