import 'package:cesizen_frontend/features/auth/domain/auth_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<AuthSession?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final session = AuthSession.fromJson(response.data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', session.accessToken);
      await prefs.setString('refresh_token', session.refreshToken);
      await prefs.setString('username', session.username);
      await prefs.setString('role', session.role);

      return session;
    } catch (e, st) {
      debugPrint('[AuthRepository] Login failed: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }


  Future<AuthSession?> register(String username, String email, String password, String confirmPassword) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      });

      final session = AuthSession.fromJson(response.data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', session.accessToken);
      await prefs.setString('refresh_token', session.refreshToken);
      await prefs.setString('username', session.username);
      await prefs.setString('role', session.role);

      return session;
    } catch (e) {
      print('[AuthRepository] Register failed: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}