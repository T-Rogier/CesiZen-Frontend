import 'package:cesizen_frontend/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/user/data/user_repository.dart';
import 'package:cesizen_frontend/features/user/domain/user.dart';
import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import 'package:cesizen_frontend/features/user/domain/create_user_request.dart';

import 'domain/user_filter_request.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
});

final usersProvider = FutureProvider.family<PaginatedResponse<User>, UserFilter>(
      (ref, filter) {
    final repo = ref.watch(userRepositoryProvider);
    return repo.fetchUsers(
      username: filter.username,
      email: filter.email,
      disabled: filter.disabled,
      role: filter.role,
      pageNumber: filter.pageNumber,
      pageSize: filter.pageSize,
    );
  },
);

final userByIdProvider = FutureProvider.family<User, String>(
      (ref, userId) {
    final repo = ref.watch(userRepositoryProvider);
    return repo.fetchUserById(userId);
  },
);

final myProfileProvider = FutureProvider<User>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchMyProfile();
});

final userRolesProvider = FutureProvider<List<String>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchUserRoles();
});

final createUserProvider = Provider<CreateUserNotifier>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return CreateUserNotifier(repo);
});

class CreateUserNotifier {
  final UserRepository _repo;
  CreateUserNotifier(this._repo);

  Future<User> createUser(CreateUserRequest req) async {
    return _repo.createUser(req);
  }
}
