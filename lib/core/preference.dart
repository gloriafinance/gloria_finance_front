import 'package:flutter/foundation.dart';

class Preferences {
  static Future<String> get API_SERVER async {
    final apiProd = 'https://church-api.jaspesoft.com/api/';
    final apiDev = 'https://church-api.abejarano.dev/api/';

    if (kReleaseMode) {
      return apiProd;
    }
    
    return apiDev;
  }
}
