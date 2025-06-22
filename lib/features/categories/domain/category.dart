class Category {
  final String id;
  final String name;
  final String iconLink;
  final bool deleted;

  Category({
    required this.id,
    required this.name,
    required this.iconLink,
    required this.deleted,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      iconLink: json['iconLink'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }
}