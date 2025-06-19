import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;

  bool get isLoggedIn => _token != null;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _token = 'fake_token';
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
  }
}