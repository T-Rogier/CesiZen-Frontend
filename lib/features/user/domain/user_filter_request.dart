class UserFilter {
  final String? username;
  final String? email;
  final bool? disabled;
  final String? role;
  final int pageNumber;
  final int pageSize;

  const UserFilter({
    this.username,
    this.email,
    this.disabled,
    this.role,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}