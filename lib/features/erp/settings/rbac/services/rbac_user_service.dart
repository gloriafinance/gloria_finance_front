import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

import '../models/rbac_user_model.dart';
import '../models/rbac_user_page.dart';
import '../models/user_authorization_model.dart';

class RbacUserService extends AppHttp {
  RbacUserService({AuthPersistence? authPersistence})
    : _authPersistence = authPersistence ?? AuthPersistence();

  final AuthPersistence _authPersistence;

  Future<RbacUserPage> fetchUsers({
    int page = 1,
    int perPage = 50,
    bool? isActive,
    bool? isSuperuser,
  }) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}user',
        queryParameters: {
          'page': page,
          'perPage': perPage,
          if (isActive != null) 'isActive': '$isActive',
          if (isSuperuser != null) 'isSuperuser': '$isSuperuser',
        },
        options: Options(headers: bearerToken()),
      );

      final envelope = _extractEnvelope(response.data);
      final records = _extractResults(envelope);
      final nextPage = _coerceInt(
        envelope['nextPag'] ?? envelope['next_page'] ?? envelope['next'],
      );
      final total = _coerceInt(envelope['count']) ?? records.length;

      return RbacUserPage(
        users: records.map(RbacUserModel.fromJson).toList(),
        page: page,
        total: total,
        nextPage: nextPage,
      );
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<RbacUserModel> createUser({
    required String name,
    required String email,
    required String password,
    bool isActive = true,
    String? memberId,
  }) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}user/create',
        data: <String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          'isActive': isActive,
          'churchId': session.churchId,
          if (memberId != null && memberId.isNotEmpty) 'memberId': memberId,
        },
        options: Options(headers: bearerToken()),
      );

      final data = _extractSingle(response.data);
      return RbacUserModel.fromJson(data);
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<UserAuthorizationModel> fetchAuthorization(String userId) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}rbac/users/$userId/permissions',
        options: Options(headers: bearerToken()),
      );

      final payload = response.data;
      if (payload is Map<String, dynamic>) {
        final data = payload['data'];
        if (data is Map<String, dynamic>) {
          return UserAuthorizationModel.fromJson(data);
        }
        return UserAuthorizationModel.fromJson(payload);
      }
      return const UserAuthorizationModel(roles: [], permissionCodes: []);
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Future<void> assignRoles({
    required String userId,
    required List<String> roleIds,
  }) async {
    final session = await _authPersistence.restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}rbac/users/$userId/assignments',
        data: <String, dynamic>{'roles': roleIds},
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (error) {
      transformResponse(error.response?.data);
      rethrow;
    }
  }

  Map<String, dynamic> _extractSingle(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dataNode = data['data'];
      if (dataNode is Map<String, dynamic>) {
        return dataNode;
      }
      return data;
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _extractEnvelope(dynamic source) {
    if (source is Map<String, dynamic>) {
      if (source.containsKey('data') &&
          source['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(
          source['data'] as Map<String, dynamic>,
        );
      }
      return Map<String, dynamic>.from(source);
    }
    return <String, dynamic>{'results': source};
  }

  List<Map<String, dynamic>> _extractResults(Map<String, dynamic> data) {
    final possibleCollections = [data['results'], data['data']];
    for (final collection in possibleCollections) {
      if (collection is List) {
        return collection.whereType<Map<String, dynamic>>().toList();
      }
    }
    if (data is Map<String, dynamic>) {
      return <Map<String, dynamic>>[data];
    }
    return const [];
  }

  int? _coerceInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }
}
