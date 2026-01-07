import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_history_model.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ContributionService extends AppHttp {
  ContributionService({super.tokenAPI});

  // Get contribution destinations (accounts/campaigns)
  Future<List<ContributionDestination>> getDestinations() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/destinations',
        options: Options(headers: bearerToken()),
      );

      final List<dynamic> data = response.data['destinations'] ?? response.data;
      return data
          .map((json) => ContributionDestination.fromJson(json))
          .toList();
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  // Create PIX charge
  Future<PixChargeResponse> createPixCharge(
    MemberContributionRequest request,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}finance/contributions/pix',
        data: {...request.toJson(), 'memberId': session.memberId},
        options: Options(headers: bearerToken()),
      );

      return PixChargeResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  // Create Boleto charge
  Future<BoletoChargeResponse> createBoletoCharge(
    MemberContributionRequest request,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      final response = await http.post(
        '${await getUrlApi()}finance/contributions/boleto',
        data: {...request.toJson(), 'memberId': session.memberId},
        options: Options(headers: bearerToken()),
      );

      return BoletoChargeResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  // Upload receipt file
  Future<String> uploadReceipt(MultipartFile file) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      'file': file,
      'memberId': session.memberId,
    });

    try {
      final response = await http.post(
        '${await getUrlApi()}finance/contributions/upload-receipt',
        data: formData,
        options: Options(headers: bearerToken()),
      );

      return response.data['url'] ?? response.data['receiptUrl'] ?? '';
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  // Register manual contribution with receipt
  Future<void> registerManualContribution(
    MemberContributionRequest request,
    MultipartFile? file,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    try {
      // Build FormData according to backend spec
      final formData = FormData.fromMap({
        'memberId': session.memberId,
        'amount': request.amount,
        'availabilityAccountId': request.destinationId,
        'contributionType': request.type.apiValue,
        if (request.financialConceptId != null)
          'financialConceptId': request.financialConceptId,
        'paidAt': DateFormat(
          'yyyy-MM-dd',
        ).format(request.paidAt ?? DateTime.now()),
        if (request.message != null && request.message!.isNotEmpty)
          'observation': request.message,
        if (file != null) 'file': file,
      });

      await http.post(
        '${await getUrlApi()}me/contribution',
        data: formData,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  // Legacy method - keep for backward compatibility
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

  // Get contribution history
  Future<MemberContributionHistoryResponse> getContributions({
    int page = 1,
    int perPage = 10,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParams = {
      'memberId': session.memberId,
      'page': page,
      'perPage': perPage,
      if (type != null && type != 'ALL') 'type': type,
      if (status != null) 'status': status,
      if (startDate != null)
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      if (endDate != null) 'endDate': DateFormat('yyyy-MM-dd').format(endDate),
    };

    try {
      final response = await http.get(
        '${await getUrlApi()}me/contribution',
        queryParameters: queryParams,
        options: Options(headers: bearerToken()),
      );

      return MemberContributionHistoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
