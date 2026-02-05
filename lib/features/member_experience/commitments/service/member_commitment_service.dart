import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:dio/dio.dart';

class MemberCommitmentService extends AppHttp {
  MemberCommitmentService({super.tokenAPI});

  Future<MemberCommitmentListResponse> fetchCommitments({
    String? status,
    int page = 1,
    int perPage = 10,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final queryParams = {
      'memberId': session.memberId,
      'page': page,
      'perPage': perPage,
      if (status != null && status.isNotEmpty) 'status': status,
    };

    try {
      final response = await http.get(
        '${await getUrlApi()}account-receivable/member/commitments',
        queryParameters: queryParams,
        options: Options(headers: bearerToken()),
      );

      return MemberCommitmentListResponse.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<void> declarePayment({
    required String accountReceivableId,
    required String installmentId,
    required String availabilityAccountId,
    required double amount,
    required DateTime paidAt,
    MultipartFile? voucher,
    String? observation,
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final formData = FormData.fromMap({
      'accountReceivableId': accountReceivableId,
      'installmentId': installmentId,
      'memberId': session.memberId,
      'availabilityAccountId': availabilityAccountId,
      'amount': amount,
      'paidAt': paidAt.toIso8601String(),
      if (observation != null && observation.isNotEmpty)
        'observation': observation,
      if (voucher != null) 'file': voucher,
    });

    try {
      await http.post(
        '${await getUrlApi()}account-receivable/member/payment-declaration',
        data: formData,
        options: Options(headers: bearerToken()),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }
}
