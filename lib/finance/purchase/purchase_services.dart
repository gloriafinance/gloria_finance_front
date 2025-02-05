import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class PurchaseService extends AppHttp {
  sendSavePurchase(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      await http.post(
        '${await getUrlApi()}purchase',
        data: formData,
        options: Options(
          headers: getHeader(),
        ),
      );

      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    }
  }
}
