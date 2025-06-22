import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import 'package:cesizen_frontend/core/utils/auth_utils.dart';
import 'package:cesizen_frontend/features/activities/domain/activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity_provider.dart';

final favoriteActivitiesProvider = FutureProvider.autoDispose<PaginatedResponse<Activity>>(
  (ref) {
    final repo = ref.watch(activityRepositoryProvider);
    return fetchIfAuthed(ref, () => repo.fetchFavoriteActivities(pageNumber:1, pageSize:10));
  },
);