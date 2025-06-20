import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String username;
  final String role;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.role,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'username': username,
      'role': role,
    };
  }

  factory AuthSession.fromPrefs(SharedPreferences prefs) {
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    final username = prefs.getString('username');
    final role = prefs.getString('role');

    if (accessToken == null || refreshToken == null || username == null || role == null) {
      throw Exception('Données de session manquantes');
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      role: role,
    );
  }
}
