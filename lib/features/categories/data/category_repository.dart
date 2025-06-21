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
}