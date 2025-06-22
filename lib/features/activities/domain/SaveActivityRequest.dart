class SaveActivityRequest {
  final bool isFavoris;
  final String state;
  final double progress;

  SaveActivityRequest({
    required this.isFavoris,
    required this.state,
    required this.progress,
  });

  Map<String, dynamic> toJson() => {
    'isFavoris': isFavoris,
    'state': state,
    'progress': progress,
  };
}