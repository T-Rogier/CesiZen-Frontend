import '../domain/category.dart';

class CategoryState {
  final List<Category> categories;
  final String? filterName;
  final int pageNumber;
  final int totalPages;
  final bool isLoadingMore;

  const CategoryState._({
    required this.categories,
    this.filterName,
    required this.pageNumber,
    required this.totalPages,
    required this.isLoadingMore,
  });

  const CategoryState.initial()
      : this._(
    categories: const [],
    filterName: '',
    pageNumber: 1,
    totalPages: 1,
    isLoadingMore: false,
  );

  CategoryState copyWith({
    List<Category>? categories,
    String? filterName,
    int? pageNumber,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return CategoryState._(
      categories: categories ?? this.categories,
      filterName: filterName ?? this.filterName,
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get hasMore => pageNumber < totalPages;
}
