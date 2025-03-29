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

  Map<String, String> getHeader() {
    var token = "Bearer $tokenAPI";
    return {HttpHeaders.authorizationHeader: token};
  }

  Future<String> getUrlApi({String apiVersion = 'v1'}) async {
    final url = await _urlServer();
    return '$url$apiVersion/';
  }

  _urlServer() async {
    final apiProd = 'https://church-api.jaspesoft.com/api/';
    //final apiDev = 'https://church-api.abejarano.dev/api/';
    final apiDev = 'http://localhost:5200/api/';

    if (!kReleaseMode) {
      return apiProd;
    }

    return apiDev;
  }

  transformResponse(data) {
    Map error = jsonDecode(jsonEncode(data));

    error.forEach((key, value) {
      if (value is String) {
        if (key != "code") {
          Toast.showMessage(value, ToastType.warning);
        }
      } else if (value is Map<String, dynamic> &&
          value.containsKey("message")) {
        String errorMessage =
            value["message"]; // Access the value using the key "message"
        Toast.showMessage(errorMessage, ToastType.warning);
      } else {
        Toast.showMessage("", ToastType.warning);
      }
    });
  }
}
