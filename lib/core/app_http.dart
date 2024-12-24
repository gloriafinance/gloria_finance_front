import 'dart:convert';
import 'dart:io';

import 'package:church_finance_bk/core/preference.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:dio/dio.dart';

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
    final url = await Preferences.API_SERVER;
    return '$url$apiVersion/';
  }

  transformResponse(data) {
    Map error = jsonDecode(jsonEncode(data));

    error.forEach((key, value) {
      if (value is String) {
        if (key != "code") {
          print(value);
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
