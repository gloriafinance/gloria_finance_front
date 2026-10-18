import 'package:dio/dio.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';

import '../models/recurring_payment_competence_model.dart';
import '../models/recurring_payment_bill_simulation.dart';
import '../models/recurring_payment_pay_result.dart';
import '../models/recurring_payment_pix_qr_data.dart';

class RecurringPaymentBillSimulationInput {
  const RecurringPaymentBillSimulationInput.barCode(String value)
    : barCode = value,
      identificationField = null;

  const RecurringPaymentBillSimulationInput.identificationField(String value)
    : barCode = null,
      identificationField = value;

  final String? barCode;
  final String? identificationField;

  Map<String, String> toJson() => {
    if (barCode != null) 'barCode': barCode!,
    if (identificationField != null)
      'identificationField': identificationField!,
  };
}

/// Ejecución mensual de las recurrencias.
///
/// A diferencia de `RecurringPaymentService` (configuración), esta capa sí
/// consume el estado de la competencia y las dos formas de pagar: bancaria
/// (Asaas) y registro manual.
class RecurringPaymentExecutionService extends AppHttp {
  /// `GET /recurring-payments?competence=YYYY-MM`
  ///
  /// Devuelve la configuración de cada recurrencia **con** su estado en esa
  /// competencia, el detalle de la operación bancaria en curso y el asiento que
  /// la dejó pagada.
  Future<List<RecurringPaymentCompetenceModel>> listCompetence(
    String competence,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}recurring-payments/',
        queryParameters: {'competence': competence},
        options: Options(headers: bearerToken()),
      );

      return (response.data as List)
          .map(
            (element) => RecurringPaymentCompetenceModel.fromJson(
              Map<String, dynamic>.from(element),
            ),
          )
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/pay`
  Future<RecurringPaymentPayResult> pay(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/pay',
        data: payload,
        options: Options(headers: bearerToken()),
      );

      return RecurringPaymentPayResult.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/pix-qr/pay`
  Future<RecurringPaymentPayResult> payPixQr(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/pix-qr/pay',
        data: payload,
        options: Options(headers: bearerToken()),
      );
      return RecurringPaymentPayResult.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/bill/simulate`
  Future<RecurringPaymentBillSimulation> simulateBill(
    String recurringPaymentId,
    RecurringPaymentBillSimulationInput input,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/bill/simulate',
        data: input.toJson(),
        options: Options(headers: bearerToken()),
      );

      return RecurringPaymentBillSimulation.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/pix-qr/decode`
  Future<RecurringPaymentPixQrData> decodePixQr(
    String recurringPaymentId,
    String availabilityAccountId,
    String payload,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/pix-qr/decode',
        data: {
          'availabilityAccountId': availabilityAccountId,
          'payload': payload,
        },
        options: Options(headers: bearerToken()),
      );
      return RecurringPaymentPixQrData.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/pix-qr/status`
  /// Reconciles an already reserved QR payment using the same stable reference.
  Future<RecurringPaymentPayResult> reconcilePixQr(
    String recurringPaymentId, {
    required String competence,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/pix-qr/status',
        data: {'competence': competence},
        options: Options(headers: bearerToken()),
      );
      return RecurringPaymentPayResult.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  /// `POST /recurring-payments/:id/register-payment` (multipart)
  ///
  /// El comprovante es obligatorio: sin él no hay `FinancialRecord`.
  Future<void> registerManually({
    required String recurringPaymentId,
    required Map<String, dynamic> payload,
    MultipartFile? voucher,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final formData = FormData.fromMap({
      ...payload,
      if (voucher != null) 'file': voucher,
    });

    try {
      await http.post(
        '${await getUrlApi()}recurring-payments/$recurringPaymentId/register-payment',
        data: formData,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
