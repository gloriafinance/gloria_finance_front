import 'package:gloria_finance/core/app_http.dart';
import 'package:dio/dio.dart';

class NotificationApi extends AppHttp {
  NotificationApi({super.tokenAPI});

  Future<void> registerToken({
    required String token,
    required String deviceId,
    required String platform,
  }) async {
    final url = await getUrlApi();
    final endpoint = '${url}notifications/push-tokens';

    try {
      await http.post(
        endpoint,
        data: {'token': token, 'platform': platform, 'deviceId': deviceId},
        options: Options(headers: bearerToken()),
      );
    } catch (e) {
      // Handle error or let it propagate. For now, we mainly want to ensure it doesn't crash the app flow
      print('Error registering push token: $e');
    }
  }
}
