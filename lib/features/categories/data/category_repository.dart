import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import 'package:cesizen_frontend/features/categories/domain/category_request.dart';
import 'package:dio/dio.dart';
import '../domain/category.dart';

class CategoryRepository {
  final Dio _dio;
  CategoryRepository(this._dio);

  Future<List<Category>> fetchCategories() async {
    final response = await _dio.get('/categories');
    final Map<String, dynamic> jsonMap = response.data as Map<String, dynamic>;
    final List<dynamic> items = jsonMap['categories'] as List<dynamic>;
    return items
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Category> fetchCategoryById(String id) async {
    final response = await _dio.get('/categories/$id');
    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PaginatedResponse<Category>> searchCategories({
    String? name,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final qName = name ?? '';
    final url = '/categories/filter?'
        'Name=$qName'
        '&PageNumber=$pageNumber'
        '&PageSize=$pageSize';

    final resp = await _dio.get(url);
    final json = resp.data as Map<String, dynamic>;
    return PaginatedResponse.fromJson(json, (e) => Category.fromJson(e), 'categories');
  }

  Future<Category> createCategory(CategoryRequest req) async {
    final response = await _dio.post(
      '/categories',
      data: req.toJson(),
    );

    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Category> updateCategory(String id, CategoryRequest req) async {
    final response = await _dio.put(
      '/categories/$id',
      data: req.toJson(),
    );

    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteCategory(String id) async {
    await _dio.delete('/categories/$id');
  }
}