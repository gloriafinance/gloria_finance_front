import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import '../models/church_model.dart';

class ChurchService extends AppHttp {
  ChurchService({super.tokenAPI});

  Future<ChurchModel> getChurch(String churchId) async {
    final url = await getUrlApi();
    try {
      final response = await http.get(
        '${url}church/$churchId',
        options: Options(headers: bearerToken()),
      );
      return ChurchModel.fromJson(response.data);
    } catch (e) {
      transformResponse(e);
      rethrow;
    }
  }

  Future<void> updateChurch(ChurchModel church) async {
    final url = await getUrlApi();
    try {
      await http.post(
        '${url}church',
        data: church.toJson(),
        options: Options(headers: bearerToken()),
      );
    } catch (e) {
      transformResponse(e);
      rethrow;
    }
  }

  Future<String> uploadLogo(MultipartFile file) async {
    final url = await getUrlApi();
    try {
      FormData formData = FormData.fromMap({'file': file});

      final response = await http.post(
        '${url}church/logo',
        data: formData,
        options: Options(headers: bearerToken()),
      );
      return response.data['url'] ?? '';
    } catch (e) {
      transformResponse(e);
      rethrow;
    }
  }
}
