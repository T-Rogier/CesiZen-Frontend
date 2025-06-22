class CreateUserRequest {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  CreateUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role,
    };
  }
}