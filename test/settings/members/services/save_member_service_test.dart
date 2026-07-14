import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/erp/settings/members/services/save_member_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CaptureAdapter implements HttpClientAdapter {
  String? method;
  String? path;
  Map<String, dynamic>? headers;
  dynamic body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    method = options.method;
    path = options.path;
    headers = options.headers;

    if (requestStream != null) {
      final bytes = <int>[];
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
      body = utf8.decode(bytes);
    }

    return ResponseBody.fromString(
      '{"message":"ok"}',
      200,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'session': jsonEncode(
        AuthSessionModel(
          token: 'token',
          refreshToken: 'refresh',
          name: 'User',
          email: 'user@example.com',
          createdAt: '2024-01-01T00:00:00.000Z',
          isActive: true,
          userId: 'user-1',
          churchId: 'church-1',
          roles: const ['ADMIN'],
        ).toJson(),
      ),
    });
  });

  test('uses POST when the payload does not include memberId', () async {
    final adapter = _CaptureAdapter();
    final service = SaveMemberService();
    service.http.httpClientAdapter = adapter;

    await service.saveMember({
      'name': 'Ana',
      'email': 'ana@example.com',
      'phone': '5511999999999',
      'dni': '12345678900',
      'conversionDate': '2024-01-01',
      'birthdate': '1990-01-01',
      'status': 'APPROVED',
      'isTreasurer': false,
    });

    expect(adapter.method, 'POST');
    expect(adapter.path, contains('/church/member'));
    expect(adapter.path, isNot(contains('/church/member/')));
  });

  test('uses PUT when the payload includes memberId', () async {
    final adapter = _CaptureAdapter();
    final service = SaveMemberService();
    service.http.httpClientAdapter = adapter;

    await service.saveMember({
      'memberId': 'member-1',
      'name': 'Ana',
      'email': 'ana@example.com',
      'phone': '5511999999999',
      'dni': '12345678900',
      'conversionDate': '2024-01-01',
      'birthdate': '1990-01-01',
      'status': 'APPROVED',
      'isTreasurer': false,
    });

    expect(adapter.method, 'PUT');
    expect(adapter.path, contains('/church/member/member-1'));
  });
}
