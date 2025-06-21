class FullActivity {
  final String id;
  final String title;
  final String description;
  final String content;
  final String thumbnailImageLink;
  final String estimatedDuration;
  final int viewCount;
  final bool activated;
  final bool deleted;
  final int createdById;
  final String createdBy;
  final List<String> categories;
  final String type;
  final bool? isFavoris;
  final String? state;
  final double? progress;

  FullActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailImageLink,
    required this.estimatedDuration,
    required this.viewCount,
    required this.activated,
    required this.deleted,
    required this.createdById,
    required this.createdBy,
    required this.categories,
    required this.type,
    this.isFavoris,
    this.state,
    this.progress,
  });

  factory FullActivity.fromJson(Map<String, dynamic> json) {
    return FullActivity(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      thumbnailImageLink: json['thumbnailImageLink'] as String? ?? '',
      estimatedDuration: json['estimatedDuration'] as String? ?? '',
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      activated: json['activated'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      createdById: (json['createdById'] as num?)?.toInt() ?? 0,
      createdBy: json['createdBy'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      type: json['type'] as String? ?? '',
      isFavoris: json['isFavoris'] as bool?,
      state: json['state'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }
}
