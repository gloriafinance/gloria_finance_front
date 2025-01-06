import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/financial_concept_model.dart';
import '../services/finance_service.dart';

part 'financial_concept_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<FinancialConceptModel>> searchFinancialConcepts(
    Ref ref, FinancialConceptType? type) async {
  AuthSessionModel session = await AuthStore().restore();

  if (session.token == '') {
    throw Exception('No se ha iniciado sesión');
  }

  return await FinanceService(tokenAPI: session.token)
      .searchFinancialConcepts(session.churchId, type);
}
