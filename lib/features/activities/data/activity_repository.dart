import 'package:cesizen_frontend/features/activities/domain/create_activity_request.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
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

  Future<FullActivity> fetchActivityById(String id) async {
    final response = await dio.get('/activities/$id');
    return FullActivity.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<String>> fetchActivityTypes() async {
    final response = await dio.get('/activities/type');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    final List<dynamic> rawList = json['activityTypes'] as List<dynamic>;
    return rawList.map((e) => e as String).toList();
  }

  Future<FullActivity> createActivity(CreateActivityRequest req) async {
    final response = await dio.post(
      '/activities',
      data: req.toJson(),
    );

    return FullActivity.fromJson(response.data as Map<String, dynamic>);
  }
}
