import 'package:church_finance_bk/auth/auth_persistence.dart';

import '../../../services/finance_record_service.dart';

Future<bool> financeRecordSave(Map<String, dynamic> payload) async {
  final service = FinanceRecordService();
  final session = await AuthPersistence().restore();

  service.tokenAPI = session.token;

  return service.sendSaveFinanceRecord(payload);
}
