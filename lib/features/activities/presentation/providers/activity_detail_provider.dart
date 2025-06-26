import 'package:cesizen_frontend/features/activities/data/activity_repository.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:flutter/material.dart';
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

  Future<void> saveProgress(double progress) async {
    final current = state.value!;
    debugPrint("$current");
    final String activityState;
    if(progress != 0){
      if(progress != 100) {
        activityState = 'En cours';
      }
      else {
        activityState = 'Terminé';
      }
    }
    else {
      activityState = 'Non commencé';
    }
    await _repo.saveActivity(
      activityId: current.id,
      isFavoris: current.isFavoris ?? false,
      state: activityState,
      progress: progress,
    );
    // met à jour le state en mémoire
    state = AsyncValue.data(
      current.copyWith(state: activityState, progress: progress),
    );
  }
}