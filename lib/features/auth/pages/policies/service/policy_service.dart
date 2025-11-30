import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';

import '../../../models/policy_acceptance_model.dart';

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

      final data = response.data as Map<String, dynamic>?;
      // Extract the policies object from the response
      final policies = data?['policies'] as Map<String, dynamic>?;
      return PolicyAcceptanceModel.fromJson(policies);
    } on DioException catch (e) {
      print("ERR ${e.response?.data}");
      transformResponse(e.response?.data);
      return null;
    }
  }
}
