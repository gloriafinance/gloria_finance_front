import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:church_finance_bk/features/erp/bank_statements/models/index.dart';
import 'package:dio/dio.dart';

class BankStatementService extends AppHttp {
  BankStatementService({super.tokenAPI});

  Future<void> importBankStatement(Map<String, dynamic> payload) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final formData = FormData.fromMap({...payload, 'file': payload['file']});

    try {
      await http.post(
        '${await getUrlApi()}bank/statements/import',
        data: formData,
        options: Options(
          headers: {
            ...bearerToken(),
            Headers.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<List<BankStatementModel>> fetchStatements(
    BankStatementFilterModel filter,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParameters = filter.toQueryParameters();

    try {
      final response = await http.get(
        '${await getUrlApi()}bank/statements',
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
        options: Options(headers: bearerToken()),
      );

      final dynamic raw = response.data;
      final Iterable<dynamic> collection;

      // La API retorna un objeto con { count, nextPag, results }
      if (raw is Map<String, dynamic> && raw['results'] is List) {
        collection = raw['results'] as List;
      } else if (raw is List) {
        // Fallback para compatibilidad con respuestas sin paginación
        collection = raw;
      } else {
        collection = const [];
      }

      return collection
          .map(
            (item) => BankStatementModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<RetryBankStatementResponse> retryStatement(
    String bankStatementId, {
    String? churchId,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final payload = <String, dynamic>{};
    if (churchId != null && churchId.isNotEmpty) {
      payload['churchId'] = churchId;
    }

    try {
      final response = await http.post(
        '${await getUrlApi()}bank/statements/$bankStatementId/retry',
        data: payload.isEmpty ? null : payload,
        options: Options(headers: bearerToken()),
      );

      return RetryBankStatementResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<LinkBankStatementResponse> linkStatement({
    required String bankStatementId,
    required String financialRecordId,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.patch(
        '${await getUrlApi()}bank/statements/$bankStatementId/link',
        data: {'financialRecordId': financialRecordId},
        options: Options(headers: bearerToken()),
      );

      return LinkBankStatementResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}

class ImportBankStatementPayload {
  final String bankId;
  final int month;
  final int year;
  final MultipartFile file;

  const ImportBankStatementPayload({
    required this.bankId,
    required this.month,
    required this.year,
    required this.file,
  });
}
