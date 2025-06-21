import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

final activityTypesProvider = FutureProvider<List<String>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.fetchActivityTypes();
});