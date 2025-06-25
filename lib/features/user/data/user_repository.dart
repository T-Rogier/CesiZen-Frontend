import 'package:cesizen_frontend/core/domain/paginated_response.dart';
import 'package:cesizen_frontend/features/user/domain/user_create_request.dart';
import 'package:cesizen_frontend/features/user/domain/user.dart';
import 'package:cesizen_frontend/features/user/domain/user_update_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<PaginatedResponse<User>> fetchUsers({
    String? query,
    bool? disabled,
    String? role,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final roleParam = role == null || role == 'all' ? '' : role;

    final url = StringBuffer('/users/filter?')
      ..write('Query=$query');

    if (disabled != null) {
      url.write('&Disabled=$disabled');
    }
    url
      ..write('&Role=$roleParam')
      ..write('&PageNumber=$pageNumber')
      ..write('&PageSize=$pageSize');

    final response = await dio.get(url.toString());

    final json = response.data as Map<String, dynamic>;
    return PaginatedResponse.fromJson(json, (e) => User.fromJson(e), 'users');
  }

  Future<User> fetchUserById(String id) async {
    final response = await dio.get('/users/$id');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> fetchMyProfile() async {
    final response = await dio.get('/users/me');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<String>> fetchUserRoles() async {
    final response = await dio.get('/users/role');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    final List<dynamic> rawList = json['userRoles'] as List<dynamic>;
    return rawList.map((e) => e as String).toList();
  }

  Future<User> createUser(UserCreateRequest req) async {
    final response = await dio.post(
      '/users',
      data: req.toJson(),
    );

    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateUser(String userId, UserUpdateRequest req) async {
    await dio.put(
      '/users/$userId',
      data: req.toJson(),
    );
  }

  Future<void> disableUserById(String id) async {
    try {
      await dio.delete('/users/$id');
    } catch (e) {
      debugPrint('[UserRepository] disableAccount failed: $e');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
