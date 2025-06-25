import 'package:cesizen_frontend/features/user/data/user_repository.dart';
import 'package:cesizen_frontend/features/user/domain/user_state.dart';
import 'package:cesizen_frontend/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
AsyncNotifierProvider.autoDispose<UserNotifier, UserState>(() => UserNotifier());

class UserNotifier extends AutoDisposeAsyncNotifier<UserState> {
  late final UserRepository _repository;

  @override
  Future<UserState> build() async {
    _repository = ref.read(userRepositoryProvider);

    final paged = await _repository.fetchUsers(query: '');
    return UserState.initial().copyWith(
      users: paged.items,
      pageNumber: paged.pageNumber,
      totalPages: paged.totalPages,
    );
  }

  Future<void> searchUsers({
    String? query,
    String? role,
    bool? disabled,
  }) async {
    state = const AsyncValue.loading();
    try {
      final paged = await _repository.fetchUsers(
        query: query,
        role: role,
        disabled: disabled,
      );
      state = AsyncValue.data(
        UserState.initial().copyWith(
          users: paged.items,
          query: query,
          selectedRole: role,
          disabled: disabled,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.pageNumber + 1;
      final paged = await _repository.fetchUsers(
        query: current.query,
        role: current.selectedRole,
        disabled: current.disabled,
        pageNumber: nextPage,
      );

      final combined = [
        ...current.users,
        ...paged.items,
      ];
      state = AsyncValue.data(
        current.copyWith(
          users: combined,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> disableUser(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.disableUserById(id);
      final paged = await _repository.fetchUsers(
        query: state.value?.query,
        role: state.value?.selectedRole,
        disabled: state.value?.disabled,
      );
      state = AsyncValue.data(
        UserState.initial().copyWith(
          users: paged.items,
          query: state.value?.query,
          selectedRole: state.value?.selectedRole,
          disabled: state.value?.disabled,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clearSearch() {
    state = AsyncValue.data(UserState.initial());
  }
}