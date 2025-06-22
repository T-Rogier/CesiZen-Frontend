import 'package:cesizen_frontend/core/network/dio_provider.dart';
import 'package:cesizen_frontend/features/categories/domain/category_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/categories/data/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(dio);
});

final categoryProvider =
AsyncNotifierProvider.autoDispose<CategoryNotifier, CategoryState>(CategoryNotifier.new);

class CategoryNotifier extends AutoDisposeAsyncNotifier<CategoryState> {
  late final CategoryRepository _repo;

  @override
  Future<CategoryState> build() async {
    _repo = ref.read(categoryRepositoryProvider);
    final paged = await _repo.searchCategories();
    return CategoryState.initial().copyWith(
      categories: paged.items,
      pageNumber: paged.pageNumber,
      totalPages: paged.totalPages,
    );
  }

  Future<void> searchCategories({String? name}) async {
    state = const AsyncValue.loading();
    try {
      final paged = await _repo.searchCategories(name: name);
      state = AsyncValue.data(
        CategoryState.initial().copyWith(
          categories: paged.items,
          filterName: name,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final cur = state.value;
    if (cur == null || !cur.hasMore || cur.isLoadingMore) return;
    state = AsyncValue.data(cur.copyWith(isLoadingMore: true));
    try {
      final next = await _repo.searchCategories(
        name: cur.filterName,
        pageNumber: cur.pageNumber + 1,
      );
      final all = [...cur.categories, ...next.items];
      state = AsyncValue.data(cur.copyWith(
        categories: all,
        pageNumber: next.pageNumber,
        totalPages: next.totalPages,
        isLoadingMore: false,
      ));
    } catch (_) {
      state = AsyncValue.data(cur.copyWith(isLoadingMore: false));
    }
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteCategory(id);
      final paged = await _repo.searchCategories(
        name: state.value?.filterName,
      );
      state = AsyncValue.data(
        CategoryState.initial().copyWith(
          categories: paged.items,
          filterName: state.value?.filterName,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}