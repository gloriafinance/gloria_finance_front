import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:dio/dio.dart';

class ContributionService extends AppHttp {
  ContributionService({super.tokenAPI});

  Future<bool> sendSaveContribution(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
      'memberId': session.memberId,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/contributions',
        data: formData,
        options: Options(headers: bearerToken()),
      );
      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
