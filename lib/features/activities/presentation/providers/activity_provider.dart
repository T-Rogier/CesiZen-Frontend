import 'package:cesizen_frontend/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/features/activities/data/activity_repository.dart';
import 'package:cesizen_frontend/features/activities/domain/activity_state.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ActivityRepository(dio);
});

final activityProvider =
AsyncNotifierProvider.autoDispose<ActivityNotifier, ActivityState>(() => ActivityNotifier());

class ActivityNotifier extends AutoDisposeAsyncNotifier<ActivityState> {
  late final ActivityRepository _repository;

  @override
  Future<ActivityState> build() async {
    _repository = ref.read(activityRepositoryProvider);

    final paged = await _repository.fetchActivities();
    return ActivityState.initial().copyWith(
      activities: paged.items,
      pageNumber: paged.pageNumber,
      totalPages: paged.totalPages,
    );
  }

  Future<void> searchActivities({
    String? query,
    String? type,
    Duration? startDuration,
    Duration? endDuration,
    List<String>? categories,
  }) async {
    state = const AsyncValue.loading();
    try {
      final paged = await _repository.fetchActivities(
        query: query,
        type: type,
        startEstimatedDuration: startDuration,
        endEstimatedDuration: endDuration,
        categories: categories,
      );
      state = AsyncValue.data(
        ActivityState.initial().copyWith(
          activities: paged.items,
          query: query,
          selectedType: type,
          startDuration: startDuration,
          endDuration: endDuration,
          selectedCategories: categories ?? const [],
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.pageNumber + 1;
      final paged = await _repository.fetchActivities(
        query: current.query,
        type: current.selectedType,
        startEstimatedDuration: current.startDuration,
        endEstimatedDuration: current.endDuration,
        categories: current.selectedCategories,
        pageNumber: nextPage,
      );

      final combined = [
        ...current.activities,
        ...paged.items,
      ];
      state = AsyncValue.data(
        current.copyWith(
          activities: combined,
          pageNumber: paged.pageNumber,
          totalPages: paged.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }

  void clearSearch() {
    state = AsyncValue.data(ActivityState.initial());
  }
}