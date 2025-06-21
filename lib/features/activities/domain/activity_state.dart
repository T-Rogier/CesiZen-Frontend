import 'activity.dart';

class ActivityState {
  final List<Activity> activities;
  final String query;
  final String selectedType;
  final String selectedDuration;
  final List<String> selectedTags;

  const ActivityState._(
      this.activities,
      this.query,
      this.selectedType,
      this.selectedDuration,
      this.selectedTags,
      );

  const ActivityState.initial()
      : this._(const [], '', '', '', const []);

  ActivityState copyWith({
    List<Activity>? activities,
    String? query,
    String? selectedType,
    String? selectedDuration,
    List<String>? selectedTags,
  }) {
    return ActivityState._(
      activities ?? this.activities,
      query ?? this.query,
      selectedType ?? this.selectedType,
      selectedDuration ?? this.selectedDuration,
      selectedTags ?? this.selectedTags,
    );
  }
}
