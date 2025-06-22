class User {
  final String id;
  final String username;
  final String email;
  final bool disabled;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.disabled,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
      disabled: json['disabled'] as bool,
      role: json['role'] ?? '',
    );
  }
}

