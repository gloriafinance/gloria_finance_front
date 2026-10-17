import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/recurring_payments/service/recurring_payment_execution_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('simulateBill sends only the selected boleto representation', () async {
    final adapter = _ResponseAdapter({
      'minimumScheduleDate': null,
      'feeInCents': null,
      'bankSlip': null,
    });
    final service =
        RecurringPaymentExecutionService()..http.httpClientAdapter = adapter;

    await service.simulateBill(
      'recurring-1',
      const RecurringPaymentBillSimulationInput.barCode('barcode-raw'),
    );

    expect(
      adapter.request!.path,
      endsWith('/recurring-payments/recurring-1/bill/simulate'),
    );
    expect(adapter.request!.method, 'POST');
    expect(adapter.request!.data, {'barCode': 'barcode-raw'});
    expect(adapter.request!.headers['Authorization'], 'Bearer ');
  });

  test(
    'manual simulation sends identificationField without payment fields',
    () async {
      final adapter = _ResponseAdapter({});
      final service =
          RecurringPaymentExecutionService()..http.httpClientAdapter = adapter;

      await service.simulateBill(
        'recurring-1',
        const RecurringPaymentBillSimulationInput.identificationField(
          'typed-line',
        ),
      );

      expect(adapter.request!.data, {'identificationField': 'typed-line'});
    },
  );
}

class _ResponseAdapter implements HttpClientAdapter {
  _ResponseAdapter(this.body);

  final Map<String, dynamic> body;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
