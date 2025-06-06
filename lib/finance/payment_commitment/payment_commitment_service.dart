import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class PaymentCommitmentService extends AppHttp {
  Future<String> confirmOrRejectPaymentCommitment(
    String token,
    String action,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final Map<String, dynamic> payload = {'token': token, 'action': action};

      final response = await http.patch(
        '${await getUrlApi()}account-receivable/confirm-payment-commitment',
        data: payload,
      );

      return response.data['contract'] as String;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return '';
    }
  }
}
