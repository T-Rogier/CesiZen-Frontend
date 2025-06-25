import 'package:cesizen_frontend/features/articles/domain/article.dart';

class MenuNode {
  final int id;
  final String title;
  final List<MenuNode> childMenus;
  final List<SimpleArticle> childArticles;

  MenuNode({
    required this.id,
    required this.title,
    required this.childMenus,
    required this.childArticles,
  });

  factory MenuNode.fromJson(Map<String, dynamic> json) {
    final menuList = (json['childMenus'] as List<dynamic>)
        .map((m) => MenuNode.fromJson(m as Map<String, dynamic>))
        .toList();
    final artList = (json['childArticles'] as List<dynamic>)
        .map((a) => SimpleArticle.fromJson(a as Map<String, dynamic>))
        .toList();
    return MenuNode(
      id: json['id'] as int,
      title: json['title'] as String,
      childMenus: menuList,
      childArticles: artList,
    );
  }
}