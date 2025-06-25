import 'package:cesizen_frontend/core/network/dio_provider.dart';
import 'package:cesizen_frontend/features/user/domain/user_update_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/user/data/user_repository.dart';
import 'package:cesizen_frontend/features/user/domain/user.dart';
import 'package:cesizen_frontend/features/user/domain/user_create_request.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
});

final userByIdProvider = FutureProvider.autoDispose.family<User, String>(
      (ref, userId) {
    final repo = ref.watch(userRepositoryProvider);
    return repo.fetchUserById(userId);
  },
);

final myProfileProvider = FutureProvider.autoDispose<User>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchMyProfile();
});

final userRolesProvider = FutureProvider.autoDispose<List<String>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchUserRoles();
});

final formUserProvider = Provider.autoDispose<FormUserNotifier>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return FormUserNotifier(repo);
});

class FormUserNotifier {
  final UserRepository _repo;
  FormUserNotifier(this._repo);

  Future<User> createUser(UserCreateRequest req) async {
    return _repo.createUser(req);
  }

  Future<void> updateUser(String userId, UserUpdateRequest req) async {
    _repo.updateUser(userId, req);
  }
}
