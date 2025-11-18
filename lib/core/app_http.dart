import 'dart:convert';
import 'dart:io';

import 'package:church_finance_bk/core/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppHttp {
  Dio http = Dio();
  late String api;
  String? tokenAPI;

  AppHttp({this.tokenAPI});

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
}
