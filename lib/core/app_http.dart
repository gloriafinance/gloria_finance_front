import 'dart:convert';
import 'dart:io';

import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppHttp {
  Dio http = Dio();
  late String api;
  String? tokenAPI;

  AppHttp({this.tokenAPI}) {
    http.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 ||
              (e.response?.data is Map &&
                  e.response?.data['message'] == 'Unauthorized.')) {
            final isRefreshRequest =
                e.requestOptions.extra['isRefreshRequest'] == true;
            final isRetryRequest =
                e.requestOptions.extra['isRetryRequest'] == true;
            if (!isRefreshRequest && !isRetryRequest) {
              final refreshed = await _refreshSession();
              if (refreshed != null) {
                final updatedHeaders = Map<String, dynamic>.from(
                  e.requestOptions.headers,
                );
                updatedHeaders[HttpHeaders.authorizationHeader] =
                    'Bearer ${refreshed.token}';

                final retryResponse = await http.request(
                  e.requestOptions.path,
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                  options: Options(
                    method: e.requestOptions.method,
                    headers: updatedHeaders,
                    responseType: e.requestOptions.responseType,
                    contentType: e.requestOptions.contentType,
                    followRedirects: e.requestOptions.followRedirects,
                    validateStatus: e.requestOptions.validateStatus,
                    receiveDataWhenStatusError:
                        e.requestOptions.receiveDataWhenStatusError,
                    sendTimeout: e.requestOptions.sendTimeout,
                    receiveTimeout: e.requestOptions.receiveTimeout,
                    extra: {
                      ...e.requestOptions.extra,
                      'isRetryRequest': true,
                    },
                  ),
                  cancelToken: e.requestOptions.cancelToken,
                  onSendProgress: e.requestOptions.onSendProgress,
                  onReceiveProgress: e.requestOptions.onReceiveProgress,
                );
                return handler.resolve(retryResponse);
              }
            }

            onUnauthorized?.call();
          }
          return handler.next(e);
        },
      ),
    );
  }

  static VoidCallback? onUnauthorized;
  static Future<void> Function(AuthSessionModel session)? onSessionRefreshed;
  static Future<AuthSessionModel?>? _refreshingSession;
  static final Dio _refreshDio = Dio();

  Map<String, String> bearerToken() {
    var token = "Bearer $tokenAPI";
    return {HttpHeaders.authorizationHeader: token};
  }

  Future<String> getUrlApi({String apiVersion = 'v1'}) async {
    final url = await _urlServer();
    return '$url$apiVersion/';
  }

  _urlServer() async {
    final apiProd = 'https://api.gloriafinance.com.br/api/';
    //final apiDev = 'https://api.gloriafinance.com.br/api/';
    final apiDev = 'http://localhost:5200/api/';

    if (kReleaseMode) {
      return apiProd;
    }

    return apiDev;
  }

  transformResponse(data) {
    final Map<String, dynamic> error = Map<String, dynamic>.from(
      jsonDecode(jsonEncode(data)),
    );

    if (error.containsKey('requiredPermission')) {
      final description = error['permissionDescription'];
      final message = error['message'] ?? 'Acesso negado.';
      final composed = StringBuffer(message)
        ..write(' Você não possui permissão para continuar.');
      if (description is String && description.trim().isNotEmpty) {
        composed.write(' $description');
      }
      Toast.showMessage(composed.toString().trim(), ToastType.warning);
      return;
    }

    var displayed = false;
    error.forEach((key, value) {
      if (value is String) {
        if (key != "code") {
          Toast.showMessage(value, ToastType.warning);
          displayed = true;
        }
      } else if (value is Map<String, dynamic> &&
          value.containsKey("message")) {
        String errorMessage =
            value["message"]; // Access the value using the key "message"
        Toast.showMessage(errorMessage, ToastType.warning);
        displayed = true;
      } else {
        Toast.showMessage("", ToastType.warning);
        displayed = true;
      }
    });

    if (!displayed) {
      Toast.showMessage(
        'Ocorreu um erro inesperado. Tente novamente.',
        ToastType.warning,
      );
    }
  }

  static Future<AuthSessionModel?> _refreshSession() async {
    _refreshingSession ??= _performRefresh().whenComplete(
      () => _refreshingSession = null,
    );
    return _refreshingSession;
  }

  static Future<AuthSessionModel?> _performRefresh() async {
    final session = await AuthPersistence().restore();
    if (session.refreshToken.isEmpty) {
      return null;
    }

    try {
      final url = await AppHttp().getUrlApi();
      final response = await _refreshDio.post(
        '${url}user/refresh-token',
        data: {'refreshToken': session.refreshToken},
        options: Options(extra: {'isRefreshRequest': true}),
      );

      final data = response.data;
      if (data is! Map) {
        return null;
      }

      final token = data['token']?.toString() ?? '';
      if (token.isEmpty) {
        return null;
      }

      final refreshToken =
          (data['refreshToken'] ?? data['refresh_token'] ?? session.refreshToken)
              .toString();

      AuthSessionModel updated;
      if (data.containsKey('email') ||
          data.containsKey('userId') ||
          data.containsKey('name')) {
        try {
          updated = AuthSessionModel.fromJson(
            Map<String, dynamic>.from(data),
          );
        } catch (_) {
          updated = session.copyWith(
            token: token,
            refreshToken: refreshToken,
          );
        }
      } else {
        updated = session.copyWith(
          token: token,
          refreshToken: refreshToken,
        );
      }

      await AuthPersistence().save(updated);
      if (onSessionRefreshed != null) {
        await onSessionRefreshed!(updated);
      }
      return updated;
    } catch (e) {
      return null;
    }
  }
}
