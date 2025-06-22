import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/core/network/dio_client.dart';
import 'package:cesizen_frontend/features/categories/data/category_repository.dart';
import 'package:cesizen_frontend/features/categories/domain/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(DioClient.create());
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).fetchCategories();
});

final categoryDetailProvider = FutureProvider.family<Category, String>((ref, id) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.fetchCategoryById(id);
});