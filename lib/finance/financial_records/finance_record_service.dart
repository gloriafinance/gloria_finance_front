import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/financial_records/models/finance_record_filter_model.dart';
import 'package:dio/dio.dart';

import 'models/finance_record_list_model.dart';

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  Future<bool> sendSaveFinanceRecord(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

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

  Future<PaginateResponse<FinanceRecordListModel>> searchFinanceRecords(
      FinanceRecordFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return PaginateResponse.fromJson(params.perPage, response.data,
          (data) => FinanceRecordListModel.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
