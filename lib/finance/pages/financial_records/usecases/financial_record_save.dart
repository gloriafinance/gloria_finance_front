import 'package:church_finance_bk/auth/auth_persistence.dart';

import '../../../services/finance_record_service.dart';
import '../state/finance_record_state.dart';

Future<bool> financeRecordSave(FormFinanceRecordState form) async {
  final service = FinanceRecordService();
  final session = await AuthPersistence().restore();

  service.tokenAPI = session.token;

  return service.sendSaveFinanceRecord(form.toJson());
}
