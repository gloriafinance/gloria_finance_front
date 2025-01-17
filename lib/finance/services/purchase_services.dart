import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';

class PurchaseService extends AppHttp {
  sendSavePurchase(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;
    // Send a request to save a purchase
  }
}
