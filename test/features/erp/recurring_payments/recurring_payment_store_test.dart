import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_model.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_service.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_form_store.dart';
import 'package:gloria_finance/features/erp/recurring_payments/store/recurring_payment_list_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RecurringPaymentListStore · iglesia', () {
    test('no recarga con la misma iglesia y sí con otra', () async {
      final service = _FakeService([
        _payment('rp-1', status: RecurringPaymentStatus.ACTIVE),
      ]);
      final store = RecurringPaymentListStore(service: service);

      await store.searchRecurringPayments(churchId: 'church-a');

      expect(await store.needsLoad(churchId: 'church-a'), isFalse);
      // Otra iglesia entra sin reiniciar la app: los datos anteriores no valen.
      expect(await store.needsLoad(churchId: 'church-b'), isTrue);
    });

    test('una lista vacía siempre se vuelve a pedir', () async {
      final store = RecurringPaymentListStore(service: _FakeService(const []));

      await store.searchRecurringPayments(churchId: 'church-a');

      expect(await store.needsLoad(churchId: 'church-a'), isTrue);
    });
  });

  group('RecurringPaymentListStore · activar/desactivar', () {
    test('no alterna si el estado no se reconoce', () async {
      final service = _FakeService([_payment('rp-1', status: null)]);
      final store = RecurringPaymentListStore(service: service);
      await store.searchRecurringPayments(churchId: 'church-a');

      final result = await store.toggleStatus(store.state.payments.first);

      expect(result, isFalse);
      expect(service.updateCalls, 0);
    });

    test('alterna el estado conocido', () async {
      final service = _FakeService([
        _payment('rp-1', status: RecurringPaymentStatus.ACTIVE),
      ]);
      final store = RecurringPaymentListStore(service: service);
      await store.searchRecurringPayments(churchId: 'church-a');

      final result = await store.toggleStatus(store.state.payments.first);

      expect(result, isTrue);
      expect(service.updateCalls, 1);
      expect(service.lastUpdatePayload?['status'], 'INACTIVE');
    });
  });

  group('RecurringPaymentFormStore · deep link', () {
    test('un id inexistente no se convierte en creación', () async {
      final service = _FakeService(const []);
      final store = RecurringPaymentFormStore(
        recurringPaymentId: 'rp-inexistente',
        symbolFormatMoney: 'R\$',
        service: service,
      );

      // El id de la URL se conserva: el formulario nunca es "creación".
      expect(store.state.isEdit, isTrue);

      await store.initialize();

      expect(store.state.isEditTargetMissing, isTrue);

      // Y guardar no hace POST: no se crea una recorrência desde una edición.
      expect(await store.submit(), isFalse);
      expect(service.createCalls, 0);
      expect(service.updateCalls, 0);
    });

    test('un id válido hidrata el formulario', () async {
      final service = _FakeService([
        _payment('rp-1', status: RecurringPaymentStatus.ACTIVE),
      ]);
      final store = RecurringPaymentFormStore(
        recurringPaymentId: 'rp-1',
        symbolFormatMoney: 'R\$',
        service: service,
      );

      await store.initialize();

      expect(store.state.isEditTargetMissing, isFalse);
      expect(store.state.name, 'Aluguel do templo');
      expect(store.state.status, RecurringPaymentStatus.ACTIVE);
    });

    test('sin tipo reconocido no está completo para guardar', () async {
      final service = _FakeService([_payment('rp-1', type: null)]);
      final store = RecurringPaymentFormStore(
        recurringPaymentId: 'rp-1',
        symbolFormatMoney: 'R\$',
        service: service,
      );

      await store.initialize();

      expect(store.state.hasKnownType, isFalse);
      expect(store.state.isComplete, isFalse);
      expect(await store.submit(), isFalse);
      expect(service.updateCalls, 0);
    });
  });
}

RecurringPaymentModel _payment(
  String id, {
  RecurringPaymentValueType? type = RecurringPaymentValueType.FIXED,
  RecurringPaymentStatus? status = RecurringPaymentStatus.ACTIVE,
}) {
  return RecurringPaymentModel(
    recurringPaymentId: id,
    churchId: 'church-a',
    name: 'Aluguel do templo',
    financialConceptId: 'concept-rent',
    costCenterId: 'cc-temple',
    type: type,
    amount: 3500,
    dayOfMonth: 10,
    status: status,
    pixDestination: null,
  );
}

class _FakeService extends RecurringPaymentService {
  _FakeService(this.payments);

  final List<RecurringPaymentModel> payments;
  int createCalls = 0;
  int updateCalls = 0;
  Map<String, dynamic>? lastUpdatePayload;

  @override
  Future<List<RecurringPaymentModel>> searchRecurringPayments() async =>
      payments;

  @override
  Future<void> createRecurringPayment(Map<String, dynamic> payload) async {
    createCalls++;
  }

  @override
  Future<void> updateRecurringPayment(
    String recurringPaymentId,
    Map<String, dynamic> payload,
  ) async {
    updateCalls++;
    lastUpdatePayload = payload;
  }
}
