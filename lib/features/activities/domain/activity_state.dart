import 'activity.dart';

class ActivityState {
  final List<Activity> activities;
  final String? query;
  final String? selectedType;
  final Duration? startDuration;
  final Duration? endDuration;
  final List<String> selectedCategories;
  final int pageNumber;
  final int totalPages;
  final bool isLoadingMore;

  const ActivityState._({
    required this.activities,
    this.query,
    this.selectedType,
    this.startDuration,
    this.endDuration,
    required this.selectedCategories,
    required this.pageNumber,
    required this.totalPages,
    required this.isLoadingMore,
  });

  const ActivityState.initial()
      : this._(
    activities: const [],
    query: '',
    selectedType: 'all',
    startDuration: null,
    endDuration: null,
    selectedCategories: const [],
    pageNumber: 1,
    totalPages: 1,
    isLoadingMore: false,
  );

  ActivityState copyWith({
    List<Activity>? activities,
    String? query,
    String? selectedType,
    Duration? startDuration,
    Duration? endDuration,
    List<String>? selectedCategories,
    int? pageNumber,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return ActivityState._(
      activities: activities ?? this.activities,
      query: query ?? this.query,
      selectedType: selectedType ?? this.selectedType,
      startDuration: startDuration ?? this.startDuration,
      endDuration: endDuration ?? this.endDuration,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get hasMore => pageNumber < totalPages;
}
