import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/recurring_payment_model.dart';

/// Acceso HTTP a las recurrencias (`/api/v1/recurring-payments`).
///
/// Alcance de este entregable: configuración (listar, crear, actualizar). Ejecución de
/// de pago no es consumida por esta capa.
class RecurringPaymentService extends AppHttp {
  /// `GET /recurring-payments`
  ///
  /// El endpoint devuelve la configuración junto del estado de la competencia corriente.
  /// Esta pantalla consume solo la configuración; `competenceStatus` es
  /// deliberadamente ignorado (pertenece al flujo de pagos del mes).
  Future<List<RecurringPaymentModel>> searchRecurringPayments() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}recurring-payments/',
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map(
            (element) => RecurringPaymentModel.fromJson(
              Map<String, dynamic>.from(element),
            ),
          )
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments`
  Future<void> createRecurringPayment(Map<String, dynamic> payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.post(
        '${await getUrlApi()}recurring-payments/',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `PUT /recurring-payments/:recurringPaymentId`
  Future<void> updateRecurringPayment(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      await http.put(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId',
        data: payload,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
