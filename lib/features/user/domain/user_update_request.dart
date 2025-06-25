class UserUpdateRequest {
  final String username;
  final String password;
  final String confirmPassword;
  final String role;

  UserUpdateRequest({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      if (username.trim().isNotEmpty) 'username': username,
      if (password.trim().isNotEmpty) 'password': password,
      if (confirmPassword.trim().isNotEmpty) 'confirmPassword': confirmPassword,
    };
  }
}