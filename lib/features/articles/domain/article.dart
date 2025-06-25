class Article {
  final int id;
  final String title;
  final String content;
  final int menuId;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.menuId,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    menuId: json['menuId'] as int,
  );
}

class SimpleArticle {
  final int id;
  final String title;

  SimpleArticle({
    required this.id,
    required this.title,
  });

  factory SimpleArticle.fromJson(Map<String, dynamic> json) => SimpleArticle(
    id: json['id'] as int,
    title: json['title'] as String,
  );
}