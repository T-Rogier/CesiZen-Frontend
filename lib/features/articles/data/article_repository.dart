import 'package:dio/dio.dart';
import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import '../domain/article.dart';
import '../domain/menu_node.dart';

class ArticleRepository {
  final Dio dio;
  ArticleRepository(this.dio);

  Future<PaginatedResponse<Article>> fetchArticles({
    String? query,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final resp = await dio.get(
      '/articles/find',
      queryParameters: {
        if (query?.isNotEmpty == true) 'Name': query,
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      },
    );
    final json = resp.data as Map<String, dynamic>;
    return PaginatedResponse.fromJson(
      json,
          (e) => Article.fromJson(e),
      'articles',
    );
  }

  Future<List<MenuNode>> fetchMenuHierarchy() async {
    final resp = await dio.get('/menus/hierarchy');
    final list = (resp.data as List<dynamic>)
        .map((e) => MenuNode.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<Article> fetchArticleById(int id) async {
    final resp = await dio.get('/articles/$id');
    return Article.fromJson(resp.data as Map<String, dynamic>);
  }
}