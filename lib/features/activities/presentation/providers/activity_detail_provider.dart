import 'package:cesizen_frontend/features/activities/data/activity_repository.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

final activityDetailProvider = AsyncNotifierProvider
    .family.autoDispose<ActivityDetailNotifier, FullActivity, String>(
      () => ActivityDetailNotifier(),
);

class ActivityDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<FullActivity, String> {
  late final ActivityRepository _repo;

  @override
  Future<FullActivity> build(String activityId) async {
    _repo = ref.read(activityRepositoryProvider);
    return _repo.fetchActivityById(activityId);
  }

  Future<void> toggleFavorite() async {
    final current = state.value!;
    final newFav = !(current.isFavoris ?? false);
    await _repo.saveActivity(
      activityId: current.id,
      isFavoris: newFav,
      state: current.state ?? 'Non commencé',
      progress: current.progress ?? 0,
    );
    // met à jour le state en mémoire
    state = AsyncValue.data(
      current.copyWith(isFavoris: newFav),
    );
  }
}