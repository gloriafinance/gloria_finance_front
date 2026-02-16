import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';

class IntegrationsService extends AppHttp {
  IntegrationsService({super.tokenAPI});
  Future<void> setWhatsappCredentials({
    required String code,
    required String redirectUri,
  }) async {
    final url = await getUrlApi();

    try {
      await http.post(
        '${url}integrations/whatsapp',
        data: {'code': code, 'redirectUri': redirectUri},
        options: Options(headers: bearerToken()),
      );
    } catch (e) {
      transformResponse(e is DioException ? e.response?.data : e);
      rethrow;
    }
  }
}
