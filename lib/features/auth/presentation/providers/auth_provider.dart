import 'package:cesizen_frontend/core/network/dio_client.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/auth/data/auth_repository.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(DioClient.create());
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
      () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository;

  @override
  Future<AuthState> build() async {
    _repository = ref.read(authRepositoryProvider);

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
    final session = await _repository.login(email, password);
    if (session != null) {
      state = AsyncValue.data(AuthState.authenticated(session));
    } else {
      state = AsyncValue.data(const AuthState.unauthenticated());
    }
  }

  Future<void> register(String username, String email, String password, String confirmPassword) async {
    state = const AsyncValue.loading();
    final session = await _repository.register(username, email, password, confirmPassword);
    if (session != null) {
      state = AsyncValue.data(AuthState.authenticated(session));
    } else {
      state = AsyncValue.data(const AuthState.unauthenticated());
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    await _repository.deleteMyProfile();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _repository.logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}
