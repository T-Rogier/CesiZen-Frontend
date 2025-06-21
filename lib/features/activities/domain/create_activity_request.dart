class CreateActivityRequest {
  final String title;
  final String description;
  final String content;               // ton HTML ou Delta JSON
  final String thumbnailImageLink;
  final String estimatedDuration;     // format "HH:mm:ss"
  final bool activated;
  final List<String> categories;
  final String type;

  CreateActivityRequest({
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailImageLink,
    required this.estimatedDuration,
    required this.activated,
    required this.categories,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'thumbnailImageLink': thumbnailImageLink,
      'estimatedDuration': estimatedDuration,
      'activated': activated,
      'categories': categories,
      'type': type,
    };
  }
}