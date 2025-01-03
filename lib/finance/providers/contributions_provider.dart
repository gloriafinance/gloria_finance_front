import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';

import '../services/contribution_service.dart';

Future<void> updateContributionStatus(
    String contributionId, ContributionStatus status) async {
  AuthSessionModel session = await AuthStore().restore();

  if (session.token == '') {
    throw Exception('No se ha iniciado sesión');
  }

  await ContributionService(tokenAPI: session.token)
      .updateContributionStatus(contributionId, status);
}
