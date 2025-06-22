import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import 'package:cesizen_frontend/features/activities/domain/create_activity_request.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../domain/activity.dart';

class ActivityRepository {
  final Dio dio;

  ActivityRepository(this.dio);

  Future<PaginatedResponse<Activity>> fetchActivities({
    String? query,
    String? type,
    Duration? startEstimatedDuration,
    Duration? endEstimatedDuration,
    List<String>? categories,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    String fmt(Duration? d) =>
        d == null ? '' : d.toString().split('.').first.padLeft(8, '0');
    final start = fmt(startEstimatedDuration);
    final end   = fmt(endEstimatedDuration);

    final title    = query ?? '';
    final typeParam = type == null || type == 'all' ? '' : type;

    final catParam = categories == null || categories.isEmpty
        ? ''
        : categories.first;

    final url = StringBuffer('/activities/filter?')
      ..write('Title=$title')
      ..write('&StartEstimatedDuration=$start')
      ..write('&EndEstimatedDuration=$end')
      ..write('&StartDate=')
      ..write('&EndDate=')
      ..write('&Activated=')
      ..write('&Category=$catParam')
      ..write('&Type=$typeParam')
      ..write('&PageNumber=$pageNumber')
      ..write('&PageSize=$pageSize');

    final response = await dio.get(url.toString());

    final json = response.data as Map<String, dynamic>;
    return PaginatedResponse.fromJson(json, (e) => Activity.fromJson(e), 'activities');
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

  String _formatDuration(Duration d) {
    twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:00';
  }
}
