import 'package:church_finance_bk/auth/models/policy_acceptance_model.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

class PolicyService extends AppHttp {
  PolicyService({super.tokenAPI});

  /// Accept policies by sending the accepted versions to the backend
  Future<PolicyAcceptanceModel?> acceptPolicies({
    required String privacyPolicyVersion,
    required String sensitiveDataPolicyVersion,
  }) async {
    try {
      final response = await http.post(
        "${await getUrlApi()}user/accept-policies",
        data: {
          'privacyPolicyVersion': privacyPolicyVersion,
          'sensitiveDataPolicyVersion': sensitiveDataPolicyVersion,
        },
        options: Options(headers: bearerToken()),
      );

      return PolicyAcceptanceModel.fromJson(
        response.data as Map<String, dynamic>?,
      );
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
      return null;
    }
  }
}
