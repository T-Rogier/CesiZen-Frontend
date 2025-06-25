import 'dart:async';
import 'package:cesizen_frontend/features/articles/data/article_repository.dart';
import 'package:cesizen_frontend/features/articles/domain/article_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/article_provider.dart';

final articlesProvider =
AsyncNotifierProvider.autoDispose<ArticlesNotifier, ArticlesState>(
      () => ArticlesNotifier(),
);

class ArticlesNotifier extends AutoDisposeAsyncNotifier<ArticlesState> {
  late final ArticleRepository _repository;

  @override
  Future<ArticlesState> build() async {
    _repository = ref.read(articleRepositoryProvider);

    final paged = await _repository.fetchArticles();
    return ArticlesState.initial().copyWith(
      articles: paged.items,
      pageNumber: paged.pageNumber,
      totalPages: paged.totalPages,
    );
  }

  Future<void> searchArticles({
    required String query
  }) async {
    state = const AsyncValue.loading();
    try {
      final paged = await _repository.fetchArticles(
        query: query,
      );
      state = AsyncValue.data(
        ArticlesState.initial().copyWith(
          articles: paged.items,
          query: query,
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
    final repo = ref.read(articleRepositoryProvider);
    try {
      final nextPage = current.pageNumber + 1;
      final paged = await repo.fetchArticles(
        query: current.query,
        pageNumber: nextPage,
      );

      final combined = [
        ...current.articles,
        ...paged.items,
      ];
      state = AsyncValue.data(
        current.copyWith(
          articles: combined,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }

  void clearSearch() {
    state = AsyncValue.data(ArticlesState.initial());
  }
}