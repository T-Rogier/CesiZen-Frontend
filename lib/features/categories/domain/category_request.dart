class CategoryRequest {
  final String name;
  final String iconLink;

  CategoryRequest({
    required this.name,
    required this.iconLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconLink': iconLink,
    };
  }
}