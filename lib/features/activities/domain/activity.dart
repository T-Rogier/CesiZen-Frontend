class Activity {
  final String id;
  final String title;
  final String createdBy;
  final String estimatedDuration;
  final String thumbnailImageLink;
  final bool activated;
  final int viewCount;

  Activity({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.estimatedDuration,
    required this.thumbnailImageLink,
    required this.activated,
    required this.viewCount,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'].toString(),
      title: json['title'],
      createdBy: json['createdBy'],
      estimatedDuration: json['estimatedDuration'] ?? '',
      thumbnailImageLink: json['thumbnailImageLink'] ?? '',
      activated: json['activated'] as bool,
      viewCount: json['viewCount'] ?? 0,
    );
  }
}

