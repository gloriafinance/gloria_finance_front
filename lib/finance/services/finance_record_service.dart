import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  Future<bool> sendSaveFinanceRecord(Map<String, dynamic> form) async {
    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/financial-record',
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
