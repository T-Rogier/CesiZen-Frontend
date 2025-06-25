import 'user.dart';

class UserState {
  final List<User> users;
  final String? query;
  final String? selectedRole;
  final bool? disabled;
  final int pageNumber;
  final int totalPages;
  final bool isLoadingMore;

  const UserState._({
    required this.users,
    this.query,
    this.selectedRole,
    this.disabled,
    required this.pageNumber,
    required this.totalPages,
    required this.isLoadingMore,
  });

  const UserState.initial()
      : this._(
    users: const [],
    query: '',
    selectedRole: 'all',
    disabled: null,
    pageNumber: 1,
    totalPages: 1,
    isLoadingMore: false,
  );

  UserState copyWith({
    List<User>? users,
    String? query,
    String? selectedRole,
    bool? disabled,
    int? pageNumber,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return UserState._(
      users: users ?? this.users,
      query: query ?? this.query,
      selectedRole: selectedRole ?? this.selectedRole,
      disabled: disabled ?? this.disabled,
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get hasMore => pageNumber < totalPages;
}
