import 'package:cesizen_frontend/core/network/dio_provider.dart';
import 'package:cesizen_frontend/features/articles/domain/article.dart';
import 'package:cesizen_frontend/features/articles/domain/menu_node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/article_repository.dart';

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ArticleRepository(dio);
});

final menuProvider = FutureProvider.autoDispose<List<MenuNode>>((ref) {
  final repo = ref.watch(articleRepositoryProvider);
  return repo.fetchMenuHierarchy();
});


final articleDetailProvider = FutureProvider.autoDispose
    .family<Article, String>((ref, id) {
  final repo = ref.watch(articleRepositoryProvider);
  return repo.fetchArticleById(int.parse(id));
});