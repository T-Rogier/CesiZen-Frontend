import 'auth_session.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final AuthSession? session;

  const AuthState._(this.status, this.session);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);
  const AuthState.loading() : this._(AuthStatus.loading, null);
  const AuthState.authenticated(AuthSession session)
      : this._(AuthStatus.authenticated, session);

  bool get isTokenValid {
    if (session == null) return false;
    final token = session!.accessToken;

    try {
      return !JwtDecoder.isExpired(token);
    } catch (_) {
      return false;
    }
  }
}
