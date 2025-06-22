import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/categories/domain/category.dart';

import 'category_notifier.dart';

final categoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).fetchCategories();
});

final categoryDetailProvider = FutureProvider.autoDispose.family<Category, String>((ref, id) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.fetchCategoryById(id);
});