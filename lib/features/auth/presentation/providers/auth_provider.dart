import 'package:cesizen_frontend/features/auth/domain/auth_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/auth/data/auth_repository.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
      () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _repo;

  @override
  Future<AuthState> build() async {
    _repo = ref.read(authRepositoryProvider);

    final prefs = await SharedPreferences.getInstance();

    try {
      final session = AuthSession.fromPrefs(prefs);
      return AuthState.authenticated(session);
    } catch (_) {
      return const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final session = await _repo.login(email, password);
    if (session != null) {
      state = AsyncValue.data(AuthState.authenticated(session));
    } else {
      state = AsyncValue.data(const AuthState.unauthenticated());
    }
  }

  Future<void> register(String username, String email, String password, String confirmPassword) async {
    state = const AsyncValue.loading();
    final session = await _repo.register(username, email, password, confirmPassword);
    if (session != null) {
      state = AsyncValue.data(AuthState.authenticated(session));
    } else {
      state = AsyncValue.data(const AuthState.unauthenticated());
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AsyncValue.data(const AuthState.unauthenticated());
  }
}
