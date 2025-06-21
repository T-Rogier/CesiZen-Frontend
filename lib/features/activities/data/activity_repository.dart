import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../domain/activity.dart';

class ActivityRepository {
  final Dio dio;

  ActivityRepository(this.dio);

  Future<List<Activity>> fetchActivities({String? query}) async {
    debugPrint('🌐 Dio GET /activities/filter?q=$query');
    try {
      final response = await dio.get(
        '/activities/filter',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'Title': query,
        },
      );
      final Map<String, dynamic> jsonMap = response.data as Map<String, dynamic>;
      final List<dynamic> items = jsonMap['activities'] as List<dynamic>;
      return items
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // ex. throw CustomException(e.message);
      rethrow;
    }
  }
}
