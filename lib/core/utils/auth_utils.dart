import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/core/domain/paginated_response.dart';

Future<PaginatedResponse<T>> fetchIfAuthed<T>(
  Ref ref,
  Future<PaginatedResponse<T>> Function() fetch,
) async {
  final authState = ref.watch(authProvider);
  final auth = authState.value;
  if (auth?.status != AuthStatus.authenticated) {
    return const PaginatedResponse.empty();
  }
  return fetch();
}