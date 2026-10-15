import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/models/recurring_payment_model.dart';

/// El contrato se parsea **estricto**: un valor que este cliente no conoce no se
/// convierte en silencio a `FIXED`/`ACTIVE`/`CPF`, porque al guardar
/// sobrescribiría la configuración real.
void main() {
  group('parsing estricto', () {
    test('reconoce los valores del contrato', () {
      expect(
        RecurringPaymentValueTypeExtension.tryFromApiValue('FIXED'),
        RecurringPaymentValueType.FIXED,
      );
      expect(
        RecurringPaymentValueTypeExtension.tryFromApiValue('VARIABLE'),
        RecurringPaymentValueType.VARIABLE,
      );
      expect(
        RecurringPaymentStatusExtension.tryFromApiValue('INACTIVE'),
        RecurringPaymentStatus.INACTIVE,
      );
      expect(PixKeyTypeExtension.tryFromApiValue('EVP'), PixKeyType.EVP);
    });

    test('devuelve null para valores desconocidos o ausentes', () {
      expect(
        RecurringPaymentValueTypeExtension.tryFromApiValue('FIXED_INDEXED'),
        isNull,
      );
      expect(RecurringPaymentValueTypeExtension.tryFromApiValue(null), isNull);
      expect(
        RecurringPaymentStatusExtension.tryFromApiValue('SUSPENDED'),
        isNull,
      );
      expect(PixKeyTypeExtension.tryFromApiValue(null), isNull);
    });

    test('fromJson deja null lo que no reconoce', () {
      final payment = RecurringPaymentModel.fromJson({
        'recurringPaymentId': 'rp-1',
        'churchId': 'church-1',
        'name': 'Aluguel',
        'financialConceptId': 'concept-1',
        'costCenterId': 'cc-1',
        'type': 'FIXED_INDEXED',
        'amount': 100,
        'dayOfMonth': 10,
        'status': 'SUSPENDED',
        'pixDestination': {'pixKey': '123', 'pixKeyType': 'IBAN'},
      });

      expect(payment.type, isNull);
      expect(payment.status, isNull);
      expect(payment.pixDestination?.pixKeyType, isNull);
      expect(payment.hasPixDestination, isTrue);
    });
  });

  group('payload', () {
    test(
      'omite status cuando no se conoce (el backend conserva el actual)',
      () {
        final payload = RecurringPaymentConfigurationPayload.build(
          name: 'Aluguel',
          financialConceptId: 'concept-1',
          costCenterId: 'cc-1',
          type: RecurringPaymentValueType.FIXED,
          amount: 3500,
          dayOfMonth: 10,
          status: null,
          pixDestination: null,
        );

        expect(payload.containsKey('status'), isFalse);
        expect(payload['type'], 'FIXED');
      },
    );

    test('omite pixDestination si el tipo de chave no se conoce', () {
      final payload = RecurringPaymentConfigurationPayload.build(
        name: 'Aluguel',
        financialConceptId: 'concept-1',
        costCenterId: 'cc-1',
        type: RecurringPaymentValueType.FIXED,
        amount: 3500,
        dayOfMonth: 10,
        status: RecurringPaymentStatus.ACTIVE,
        pixDestination: const RecurringPixDestination(pixKey: '123'),
      );

      expect(payload.containsKey('pixDestination'), isFalse);
      expect(payload['status'], 'ACTIVE');
    });

    test('en VARIABLE no se envía amount', () {
      final payload = RecurringPaymentConfigurationPayload.build(
        name: 'Energia',
        financialConceptId: 'concept-1',
        costCenterId: 'cc-1',
        type: RecurringPaymentValueType.VARIABLE,
        amount: 999,
        dayOfMonth: 15,
        status: RecurringPaymentStatus.ACTIVE,
        pixDestination: null,
      );

      expect(payload.containsKey('amount'), isFalse);
    });

    test('toConfigurationJson exige un tipo conocido', () {
      final payment = RecurringPaymentModel(
        recurringPaymentId: 'rp-1',
        churchId: 'church-1',
        name: 'Aluguel',
        financialConceptId: 'concept-1',
        costCenterId: 'cc-1',
        type: null,
        amount: null,
        dayOfMonth: 10,
        status: RecurringPaymentStatus.ACTIVE,
        pixDestination: null,
      );

      expect(payment.toConfigurationJson, throwsStateError);
    });
  });
}
