import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import 'helpers.dart';
import 'state/finance_record_state.dart';

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  Future<void> createFinanceRecord(FormFinanceRecordState params) async {
    try {
      FormData formData = FormData.fromMap({
        'file': params.file,
        'financeConceptId': params.financialConceptId,
        'bankId': params.bankId,
        'amount': params.amount,
        'date': convertDateFormat(params.date),
        'moneyLocation': params.moneyLocation,
      });

      final response = await http.post(
        '${await getUrlApi()}finance/financial-record',
        data: formData,
        options:
            Options(headers: getHeader(), contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
