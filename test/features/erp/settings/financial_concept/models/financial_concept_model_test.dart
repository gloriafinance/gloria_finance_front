import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';

void main() {
  test('hydrates tag and optional static PIX payload returned by the API', () {
    final concept = FinancialConceptModel.fromJson({
      'financialConceptId': 'concept-1',
      'name': 'Dízimos de Membros',
      'description': 'Dízimos regulares',
      'active': true,
      'type': 'INCOME',
      'statementCategory': 'REVENUE',
      'churchId': 'church-1',
      'tag': 'Tithes',
      'createdAt': '2025-01-25T23:57:42.619Z',
      'affectsCashFlow': true,
      'affectsResult': true,
      'affectsBalance': false,
      'isOperational': true,
      'pix': {
        'pixQrCodeId': 'qr-1',
        'copyPaste': '000201...',
        'encodedImage': 'iVBORw0KGgo=',
      },
    });

    expect(concept.tag, 'Tithes');
    expect(concept.pix?.pixQrCodeId, 'qr-1');
    expect(concept.pix?.copyPaste, '000201...');
    expect(concept.pix?.encodedImage, 'iVBORw0KGgo=');
  });

  test('keeps PIX absent when the API omits the optional payload', () {
    final concept = FinancialConceptModel.fromJson({
      'financialConceptId': 'concept-1',
      'name': 'Ofertas de Cultos',
      'description': 'Ofertas',
      'active': true,
      'type': 'INCOME',
      'statementCategory': 'REVENUE',
      'churchId': 'church-1',
      'tag': 'Offering',
      'createdAt': '2025-01-25T23:57:42.619Z',
      'affectsCashFlow': true,
      'affectsResult': true,
      'affectsBalance': false,
      'isOperational': true,
    });

    expect(concept.tag, 'Offering');
    expect(concept.pix, isNull);
  });
}
