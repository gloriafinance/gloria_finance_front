import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/banks/bank_service.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/asaas_connection_model.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/state/asaas_connection_state.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/asaas_connection/store/asaas_connection_store.dart';

void main() {
  test(
    'submits only the API Key and clears it after a successful connection',
    () async {
      final service = _FakeBankService();
      final store = AsaasConnectionStore(service: service)
        ..setApiKey(' key-123 ');

      final connected = await store.connect();

      expect(connected, isTrue);
      expect(service.submittedApiKey, 'key-123');
      expect(store.state.step, AsaasConnectionStep.confirmation);
      expect(store.state.apiKey, isEmpty);
      expect(store.state.connection?.status, 'ACTIVE');
    },
  );

  test('does not submit an empty API Key', () async {
    final service = _FakeBankService();
    final store = AsaasConnectionStore(service: service);

    final connected = await store.connect();

    expect(connected, isFalse);
    expect(service.submittedApiKey, isNull);
    expect(store.state.step, AsaasConnectionStep.form);
  });
}

class _FakeBankService extends BankService {
  String? submittedApiKey;

  @override
  Future<AsaasConnectionModel> connectAsaasAccount({
    required String apiKey,
  }) async {
    submittedApiKey = apiKey;
    return const AsaasConnectionModel(
      accountId: 'account-id',
      externalAccountId: 'external-account-id',
      status: 'ACTIVE',
      connectionMode: 'EXTERNAL_API_KEY',
    );
  }
}
