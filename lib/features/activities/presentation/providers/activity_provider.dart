import 'package:cesizen_frontend/core/network/dio_client.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/activities/data/activity_repository.dart';
import 'package:cesizen_frontend/features/activities/domain/activity_state.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final dio = DioClient.create();
  return ActivityRepository(dio);
});

final activityProvider =
AsyncNotifierProvider<ActivityNotifier, ActivityState>(() => ActivityNotifier());

class ActivityNotifier extends AsyncNotifier<ActivityState> {
  late final ActivityRepository _repository;

  @override
  Future<ActivityState> build() async {
    debugPrint('🔧 ActivityNotifier.build()');
    _repository = ref.read(activityRepositoryProvider);

    final list = await _repository.fetchActivities();
    return ActivityState.initial().copyWith(activities: list);
  }

  Future<void> searchActivities({
    String? query,
    String? selectedType,
    String? selectedDuration,
    List<String>? selectedTags
  }) async {
    state = const AsyncValue.loading();
    try {
      final activities = await _repository.fetchActivities(
        query: query ?? state.value?.query ?? '',
      );
      debugPrint('✅ fetchActivities returned ${activities.length} items');

      state = AsyncValue.data(
        state.value!.copyWith(
          activities: activities,
          query: query ?? state.value!.query,
          selectedType: selectedType ?? state.value!.selectedType,
          selectedDuration: selectedDuration ?? state.value!.selectedDuration,
          selectedTags: selectedTags ?? state.value!.selectedTags,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clearSearch() {
    state = AsyncValue.data(ActivityState.initial());
  }
}