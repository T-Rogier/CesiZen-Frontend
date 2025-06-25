import 'article.dart';

class ArticlesState {
  final List<Article> articles;
  final String query;
  final int pageNumber;
  final int totalPages;
  final bool isLoadingMore;

  const ArticlesState._({
    required this.articles,
    required this.query,
    required this.pageNumber,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  const ArticlesState.initial()
      : this._(
    articles: const [],
    query: '',
    pageNumber: 1,
    totalPages: 1,
    isLoadingMore: false,
  );

  bool get hasMore => pageNumber < totalPages;

  ArticlesState copyWith({
    List<Article>? articles,
    String? query,
    int? pageNumber,
    int? totalPages,
    bool? isLoadingMore,
  }) =>
      ArticlesState._(
        articles: articles ?? this.articles,
        query: query ?? this.query,
        pageNumber: pageNumber ?? this.pageNumber,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}