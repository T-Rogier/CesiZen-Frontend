import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

final activityDetailProvider = FutureProvider.family<FullActivity, String>((ref, activityId) {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.fetchActivityById(activityId);
});